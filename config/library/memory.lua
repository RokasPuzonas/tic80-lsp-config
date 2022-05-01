---@meta

---
---This function copies a continuous block of `RAM` from one address to another.
---Addresses are specified in hexadecimal format, values are decimal.
---
---@param to number # the address you want to write to
---@param from number # the address you want to copy from
---@param length number # the length of the memory block you want to copy (in bytes)
function memcpy(to, from, length) end

---
---This function sets a continuous block of `RAM` to the same value.
---The address is specified in hexadecimal format, the value in decimal.
---
---@param addr number # the address of the first byte of `RAM` you want to write to
---@param value number # the value you want to write (0..255)
---@param length number # the length of the memory block you want to set
function memset(addr, value, length) end

---
---This function allows you to save and retrieve data in one of the 256 individual 32-bit slots available in the cartridge's persistent memory. This is useful for saving high-scores, level advancement or achievements. Data is stored as unsigned 32-bit integer (from 0 to 4294967295).
---
---When writing a new value the previous value is returned.
---
---@param index number # an index (0..255) into the persistent memory of a cartridge.
---@param val32 number # the current/prior value saved to the specified memory slot.
---@return number val32 # the current/prior value saved to the specified memory slot.
function pmem(index, val32) end

---
---This function allows you to read directly from RAM. It can be used to access resources created with the integrated tools, such as the sprite, map and sound editors, as well as cartridge data.
---
---The requested number of bits is read from the address requested.  The address is typically specified in hexadecimal format.
---
---See also:
---
---- `poke` - Write to a memory address
---
---@param addr number # the address of `RAM` you desire to read (segmented based on `bits`)
---@param bits? number # the number of bits to read (1, 2, 4, or 8) from address (default: 8)
---@return number value # a number that depends on how many bits were read
function peek(addr, bits) end

---
---This function allows you to read directly from RAM. It can be used to access resources created with the integrated tools, such as the sprite, map and sound editors, as well as cartridge data.
---
---The requested number of bits is read from the address requested.  The address is typically specified in hexadecimal format.
---
---See also:
---
---- `poke` - Write to a memory address
---
---@param bitaddr number # the address of [RAM](RAM) you desire to write
---@return number bitval # the integer value write to RAM
function peek1(bitaddr) end

---
---This function allows you to read directly from RAM. It can be used to access resources created with the integrated tools, such as the sprite, map and sound editors, as well as cartridge data.
---
---The requested number of bits is read from the address requested.  The address is typically specified in hexadecimal format.
---
---See also:
---
---- `poke` - Write to a memory address
---
---@param addr2 number # the address of [RAM](RAM) you desire to write (segmented on 2)
---@return number val2 # the integer value write to RAM (segmented on 2)
function peek2(addr2) end

---
---This function allows you to read directly from RAM. It can be used to access resources created with the integrated tools, such as the sprite, map and sound editors, as well as cartridge data.
---
---The requested number of bits is read from the address requested.  The address is typically specified in hexadecimal format.
---
---See also:
---
---- `poke` - Write to a memory address
---
---@param addr4 number # the address of [RAM](RAM) you desire to write (segmented on 4)
---@return number val4 # the integer value write to RAM (segmented on 4)
function peek4(addr4) end

---
---This function allows you to write directly to `RAM`.  The requested number of bits is written at the address requested.  The address is typically specified in hexadecimal format.
---
---For in-depth detail on how addressing works with various `bits` parameters, please see `peek`.
---
---See also:
---
---- `peek` - Read from a memory address
---
---@param addr number # the address of `RAM` you desire to write (segmented based on `bits`)
---@param val number # the integer value write to RAM (range varies based on `bits`)
---@param bits? number # the number of bits to write (1, 2, 4, or 8; default: 8)
function poke(addr, val, bits) end

---
---This function allows you to write directly to `RAM`.  The requested number of bits is written at the address requested.  The address is typically specified in hexadecimal format.
---
---For in-depth detail on how addressing works with various `bits` parameters, please see `peek`.
---
---See also:
---
---- `peek` - Read from a memory address
---
---@param bitaddr number # the address of [RAM](RAM) you desire to write
---@param bitval number # the integer value write to RAM
function poke1(bitaddr, bitval) end

---
---This function allows you to write directly to `RAM`.  The requested number of bits is written at the address requested.  The address is typically specified in hexadecimal format.
---
---For in-depth detail on how addressing works with various `bits` parameters, please see `peek`.
---
---See also:
---
---- `peek` - Read from a memory address
---
---@param addr2 number # the address of [RAM](RAM) you desire to write (segmented on 2)
---@param val2 number # the integer value write to RAM (segmented on 2)
function poke2(addr2, val2) end

---
---This function allows you to write directly to `RAM`.  The requested number of bits is written at the address requested.  The address is typically specified in hexadecimal format.
---
---For in-depth detail on how addressing works with various `bits` parameters, please see `peek`.
---
---See also:
---
---- `peek` - Read from a memory address
---
---@param addr4 number # the address of [RAM](RAM) you desire to write (segmented on 4)
---@param val4 number # the integer value write to RAM (segmented on 4)
function poke4(addr4, val4) end

---
---Use `sync()` to save data you modify during runtime and would like to persist, or to restore runtime data from the cartridge.  For example, if you have manipulated the runtime memory (e.g. by using `mset`), you can reset the active state by calling `sync(0,0,false)`. This resets the whole of runtime memory to the contents of bank 0.
---
---Note that `sync` is never used to load _code_ from banks; this is done automatically.  All data is restored from cartridge on every startup.
---
---_Note:_ In older versions of TIC-80, calling `sync` was not required to save runtime map and sprite data. Sync should be called any time changes to the sprites and map are made during runtime if you'd like the changes to be applied.
---
---
------
---
---@param mask? number # mask of sections you want to switch: (default: 0)
---@param bank? number # memory bank (0..7) (default: 0)
---@param tocart? boolean # `true` - save memory from runtime to bank/cartridge, `false` - load data from bank/cartridge to runtime. (default: false)
function sync(mask, bank, tocart) end

---
---VRAM is double-banked, such that the entire 16kb VRAM address space can be "swapped" at any time between banks 0 and 1.  This is most commonly used for layering effects (background vs foreground layers, or a HUD that sits overtop of your main gameplay area, etc).
---
---Note: `vbank` should not be confused with `sync`.  VRAM banks can be switched
---many times during a single `TIC` (though this isn't common) - this is not true for the other banked RAM.
---
---@param id number # the VRAM bank ID to switch to (0 or 1)
function vbank(id) end

