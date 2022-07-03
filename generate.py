#!/bin/python3
import requests
from os import path
import os
import re
from dataclasses import dataclass

@dataclass
class MarkdownSection:
    name: str
    body: str
    subsections: dict[str, "MarkdownSection"]

ROOT_RAW_URL = "https://raw.githubusercontent.com/wiki/nesbox/TIC-80"
ROOT_URL = "https://github.com/nesbox/TIC-80/wiki"

def get_url_for(item: str) -> str:
    return path.join(ROOT_RAW_URL, item) + ".md"

def get_contents(url: str):
    res = requests.get(url)
    return res.content.decode()

def group_by_sections(markdown: str, min_level = 1) -> list[MarkdownSection]:
    sections = []

    # Find the lowest given section level from the text
    level = min_level
    header_prefix = ""
    while True:
        header_prefix = "#" * level
        if re.search(f"^{header_prefix}\\s+(.+)\\s*\n", markdown, re.MULTILINE) != None:
            break
        level += 1
        if level == 8:
            return []

    # Find all headers of the same level
    header_prefix = "#" * level
    headers = list(h for h in re.finditer(f"^{header_prefix}\\s+(.+)\\s*\n", markdown, re.MULTILINE))

    for i in range(len(headers)):
        header = headers[i]
        header_start = header.end()

        # The size of the whole section (including sub-sections)
        section_end = -1
        if i+1 < len(headers):
            section_end = headers[i+1].start()
        section_markdown = markdown[header_start:section_end]

        # Find all subsections and save them
        subsections = {}
        for subsection in group_by_sections(section_markdown, level+1):
            subsections[subsection.name] = subsection

        # Determine body size (just text that isin't part of a subsection)
        body_end = -1
        next_neighbour_header = re.search(f"^{header_prefix}.+\n", markdown[header_start:], re.MULTILINE)
        if next_neighbour_header != None:
            body_end = header_start + next_neighbour_header.start()
        body = markdown[header_start:body_end].strip()

        # Save subsection
        sections.append(MarkdownSection(
            name = header.group(1),
            body = body,
            subsections = subsections
        ))

    return sections

def extract_function_names(functions_section: MarkdownSection) -> dict[str, list[str]]:
    function_names = {}
    for subsection in functions_section.subsections.values():
        names = []
        for line in subsection.body.splitlines():
            match = re.search(r"\[(.*?)\]", line)
            if not match:
                raise Exception(f"Couldn't extract function name from: '{line}'")
            names.append(match.group(1))
        function_names[subsection.name.lower()] = names
    return function_names

def list_available_functions() -> dict[str, list[str]]:
    api_url = get_url_for("API")
    contents = get_contents(api_url)
    top_section = group_by_sections(contents)[0]
    return extract_function_names(top_section.subsections["Functions"])

def get_root_section_of_function(function_name) -> MarkdownSection:
    contents = get_contents(get_url_for(function_name))
    top_sections = group_by_sections(contents)
    if len(top_sections) == 0:
        match = re.search(r"^Please see: \[.+\]\((.+)\)", contents, re.MULTILINE)
        if match == None:
            raise Exception(f"Failed to fetch contents of function: '{function_name}'")
        contents = get_contents(get_url_for(match.group(1)))
        top_sections = group_by_sections(contents)

    # TYPO: Because there is a type in `rectb`, where the top level header starts from "##"
    # There needs to be some extra logic to see if that is the case
    if len(top_sections) > 1:
        # If it is the case, just skip the first "#" character
        top_sections = group_by_sections(contents[1:])

    return top_sections[0]

# Example line: `mouse() -> x, y, left, middle, right, scrollx, scrolly`
def get_function_signature(function_name: str, description: str) -> tuple[list[tuple[str, str|None]], list[str]]:
    # TYPO: Because there is a typo in the signature for `keyp`.
    # The simplest solution is to just hard-code the value for the time being.
    if function_name == "keyp":
        return ([("code", "nil"), ("hold", "nil"), ("period", "nil")], ["pressed"])

    # TYPO: Because `vbank` is not documented in a strictly formatted way,
    # it needs to be hard-coded here
    if function_name == "vbank":
        return ([("id", None)], [])

    params: list[tuple[str, str|None]] = []
    return_vars: list[str] = []

    # There could exist multiple signatures, so its important too loop through
    # all of them
    for match in re.finditer(rf"`{function_name}\s*\((.*)\)( -> ([\w\, ]+))?`", description):
        if match.group(3) != None and len(return_vars) == 0:
            return_vars = list(v.strip().replace(" ", "_") for v in match.group(3).split(","))

        if len(match.group(1)) > 0:
            match_params = match.group(1).split(",")
            for i in range(len(match_params)):
                match_param = match_params[i].strip()
                default = None
                name = match_param
                if name[0] == "[" or name[-1] == "]":
                    equal_sign = match_param.find("=")
                    # TYPO: Because there is a typo in `btnp` there needs to be some
                    # extra logic for stripping extra "[]" symbols
                    if equal_sign > 0:
                        name = match_param[1:equal_sign]
                        default = match_param[equal_sign+1:-1]
                    else:
                        name = match_param
                        default = "nil"
                    name = name.strip("[]")
                if i == len(params):
                    params.append((name.replace(" ", "_"), default))

    return (params, return_vars)

# Example line: * **text** : any string to be printed to the screen
# Example line: * **x, y** : the [coordinates](coordinate) of the circle's center
# Example line (from clip): * **x**, **y** : [coordinates](coordinate) of the top left of the clipping region
# Example line (from mouse): * **x y** : [coordinates](coordinate) of the mouse pointer
def parse_variable_description_line(line: str) -> tuple[list[str], str]:
    match = re.match(r"[\*-] \*\*(.+)\*\*\s*:\s*(.+)", line)
    if not match:
        raise Exception(f"Failed to parse parameter descriptions: '{line}'")

    description = match.group(2)
    description = replace_relative_links(description)

    names = list(name.strip(" *").replace(" ", "_") for name in match.group(1).split(","))

    # TYPO: Adjust result, because there is a typo in `mouse`
    if "x_y" in names:
        names.remove("x_y")
        names.append("x")
        names.append("y")

    return (names, description)

def get_variable_descriptions(root: MarkdownSection) -> dict[str, str]:
    descriptions = {}
    search_lines = []

    if "Parameters" in root.subsections:
        search_lines.extend(root.subsections["Parameters"].body.splitlines())
    elif "**Parameters**" in root.body:
        params_header_match = re.search(r"\*\*Parameters\*\*", root.body)
        assert params_header_match
        params_start = params_header_match.end()
        search_lines.extend(root.body[params_start:].strip().splitlines())
    if "Returns" in root.subsections:
        search_lines.extend(root.subsections["Returns"].body.splitlines())

    for line in search_lines:
        if line.startswith("* **") or line.startswith("- **"):
            names, description = parse_variable_description_line(line)
            for name in names:
                descriptions[name] = replace_relative_links(description)

    # TYPO: Because a line explaning the variable "value" in `peek` is missing,
    # It is hard-coded here
    if root.name == "peek*":
        descriptions["value"] = "a number that depends on how many bits were read"

    # TYPO: Because "bitaddr", "bitval", "addr2", "addr4", "val2", "val4" are
    # not explicitly explained in `peek` and `poke`, it is hard-coded here
    if root.name == "peek*" or root.name == "poke*":
        descriptions["bitaddr"] = "the address of `RAM` you desire to write"
        descriptions["bitval"] = "the integer value write to RAM"
        descriptions["addr2"] = "the address of `RAM` you desire to write (segmented on 2)"
        descriptions["val2"] = "the integer value write to RAM (segmented on 2)"
        descriptions["addr4"] = "the address of `RAM` you desire to write (segmented on 4)"
        descriptions["val4"] = "the integer value write to RAM (segmented on 4)"

    # Because the return type in `fget` is "bool" and is not explicitly documented
    # it is addded here
    descriptions["bool"] = "a boolean"

    return descriptions

def replace_relative_links(markdown: str) -> str:
    return re.sub(
            r"\[(.+?)\]\((.+?)\)",
            lambda s: s.group(0) if s.group(2).startswith("http") else f"`{s.group(1)}`",
            markdown
        )

def remove_non_printable(text: str) -> str:
    return ''.join(c for c in text if c.isprintable() or c == '\n')

def get_function_description(root: MarkdownSection) -> str:
    # TYPO: Because `exit` is not strictly formatted, the description is hard-coded
    if root.name == "exit":
        return """This function causes program execution to be terminated **after** the current `TIC` function ends. The entire function is executed, including any code that follows `exit()`. When the program ends you are returned to the [console](console).

See the example below for a demonstration of this behavior."""
    # TYPO: Because `reset` is not strictly formatted, the description is hard-coded
    if root.name == "reset":
        return """Resets the TIC virtual "hardware" and immediately restarts the cartridge.

To simply return to the console, please use `exit`.

See also:

- `exit`"""

    description = root.subsections["Description"].body
    return replace_relative_links(description)

def prefix_lines(text: str, prefix: str) -> str:
    return "\n".join(prefix+line for line in text.splitlines())

def guess_variable_types(descriptions: dict[str, str], func_params: list[tuple[str, str|None]]) -> dict[str, str]:
    type_names = {}
    default_type_lookup = {}
    for param in func_params:
        if param[1] != None:
            if param[1] == "false" or param[1] == "true":
                default_type_lookup[param[0]] = "boolean"
            elif param[1].isdigit():
                default_type_lookup[param[0]] = "number"

    number_variable_names = [
        "id", "track", "tempo", "speed", "duration", "note",
        "value", "val32",
        "radius", "scale", "w", "h", "sx", "sy",
        "period", "hold", "code", "length", "timestamp", "scrollx", "scrolly"
    ]
    for var_name, desc in descriptions.items():
        if var_name in default_type_lookup:
            type_names[var_name] = default_type_lookup[var_name]
        elif var_name in number_variable_names or \
            "width" in var_name or \
            "height" in var_name or \
            "color" in var_name or \
            "index" in desc or \
            "number" in desc or \
            "coordinate" in desc or \
            "integer" in desc or \
            "address" in desc or \
            "radius" in desc:
            type_names[var_name] = "number"
        elif var_name in ["pressed", "bool"] or \
            "true" in desc or \
            "false" in desc:
            type_names[var_name] = "boolean"
        elif var_name == "text" or "message" in desc:
            type_names[var_name] = "string"
        elif "function" in desc:
            type_names[var_name] = "function"
        else:
            type_names[var_name] = "MISSING_TYPE"
    return type_names

def create_lua_function(function_name: str):
    root = get_root_section_of_function(function_name)

    param_vars, return_vars = get_function_signature(function_name, root.body)

    func_signature = f"function {function_name}("
    func_signature += ", ".join(list(p[0] for p in param_vars))
    func_signature += ") end"

    doc_comment = "---\n"

    func_description = get_function_description(root)
    func_description = remove_non_printable(func_description)
    doc_comment += prefix_lines(func_description, "---")
    doc_comment += "\n---"

    var_descriptions = get_variable_descriptions(root)
    var_types = guess_variable_types(var_descriptions, param_vars)
    for param in param_vars:
        param_name, default = param
        is_optional = "?" if default != None else ""
        param_description = var_descriptions[param_name]
        type_name = var_types[param_name]
        doc_comment += f"\n---@param {param_name}{is_optional} {type_name} # {param_description}"

        if "default" not in param_description and default != None and default != "nil":
            doc_comment += f" (default: {default})"

    for return_var in return_vars:
        return_description = var_descriptions[return_var]
        type_name = var_types[return_var]
        doc_comment += f"\n---@return {type_name} {return_var} # {return_description}"

    return doc_comment + "\n" + func_signature

def main():
    library_path = "library"
    os.makedirs(library_path, exist_ok=True)
    for section_name, funcs in list_available_functions().items():
        with open(f"{library_path}/{section_name}.lua", "w") as f:
            f.write("---@meta\n\n")
            for func in funcs:
                f.write(create_lua_function(func))
                f.write("\n\n")

if __name__ == "__main__":
    main()
