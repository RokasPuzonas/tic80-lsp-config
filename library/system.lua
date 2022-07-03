---@meta

---
---This function causes program execution to be terminated **after** the current `TIC` function ends. The entire function is executed, including any code that follows `exit()`. When the program ends you are returned to the [console](console).
---
---See the example below for a demonstration of this behavior.
---
function exit() end

---
---Resets the TIC virtual "hardware" and immediately restarts the cartridge.
---
---To simply return to the console, please use `exit`.
---
---See also:
---
---- `exit`
---
function reset() end

---
---This function returns the number of _milliseconds_ elapsed since the cartridge began execution. Useful for keeping track of time, animating items and triggering events.
---
---@return number ticks # the number of _milliseconds_ elapsed since the game was started
function time() end

---
---This function returns the number of _seconds_ elapsed since January 1st, 1970.  This can be quite useful for creating persistent games which evolve over time between plays.
---
---@return number timestamp # the current Unix timestamp in _seconds_
function tstamp() end

---
---This is a service function, useful for debugging your code. It prints the supplied string or variable to the console in the (optional) color specified.
---
---_Tips:_
---
---1. The Lua concatenation operator is `..` (two periods)
---2. Use the console `cls` command to clear the output from trace
---
---@param message string # the message to print in the `console`.
---@param color? number # the index of a color in the current `palette` (0..15) (default: 15)
function trace(message, color) end

