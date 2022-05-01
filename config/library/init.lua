---@meta

---
---This function allows you to write directly to RAM. The requested number of bits is written at the address requested. The address is typically specified in hexadecimal format.
---
---For in-depth detail on how addressing works with various bits parameters, please see `peek`.
---
---@param addr number # the address of RAM you desire to write (segmented based on bits)
---@param val number # the integer value write to RAM (range varies based on bits)
---@param bits number # the number of bits to write (1, 2, 4, or 8; default: 8)
function poke(addr, val, bits) end
