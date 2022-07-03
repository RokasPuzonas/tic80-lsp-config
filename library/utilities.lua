---@meta

---
---Returns `true` if the specified flag of the sprite is set.
---
---See also:
---
---* `fset` (0.8
---
---@param sprite_id number # sprite index (0..511)
---@param flag number # flag index to check (0..7)
---@return boolean bool # a boolean
function fget(sprite_id, flag) end

---
---This function sets the sprite flag to a given boolean value. Each sprite has eight flags which can be used to store information or signal different conditions. For example, flag 0 might be used to indicate that the sprite is invisible, flag 6 might indicate that the sprite should be drawn scaled etc.
---
---To read the value of sprite flags, see `fget`.
---
---@param sprite_id number # sprite index (0..511)
---@param flag number # index of flag (0-7) to set
---@param bool boolean # a boolean
function fset(sprite_id, flag, bool) end

---
---This function returns the tile at the specified `MAP` coordinates, the top left cell of the map being (0, 0).
---
---@param x number # map coordinates
---@param y number # map coordinates
---@return number tile_id # returns the tile id at the given coordinates
function mget(x, y) end

---
---This function will change the tile at the specified `MAP` coordinates. By default, changes made are only kept while the current game is running. To make permanent changes to the map (persisting them back to the cartridge), see `sync`.
---
---@param x number # map coordinates
---@param y number # map coordinates
---@param tile_id number # The background tile (0-255) to place in map at specified coordinates.
function mset(x, y, tile_id) end

