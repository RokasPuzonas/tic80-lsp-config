---@meta

---
---The **TIC** function is the 'main' update/draw callback and **must** be present in every program. It takes no parameters and is called sixty times per second (60fps).
---
function TIC() end

---
---The **BOOT** function is called a single time when your cartridge is booted. It should be used for startup/initialization code.  For scripting languages that allow code in the global scope (Lua, etc.) using `BOOT` is preferred rather than including source code in the global scope.
---
function BOOT() end

---
---The **BDR** callback allows you to execute code _between_ the rendering of each scan line. The primary reason to do this is to manipulate the `palette`.  Doing so makes it possible to use a different palette for each scan line, and therefore `more than 16 colors at a time`.
---
---@param scanline number # The scan line about to be drawn (0..143)
function BDR(scanline) end

---
---The **OVR** callback is the final step in rendering a frame. It draws on a separate layer and can be used together with `BDR` to create separate background or foreground layers and other visual effects.
---
function OVR() end
