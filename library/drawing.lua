---@meta

---
---This function draws a filled circle of the desired **radius** and **color** with its center at **x**, **y**. It uses the _Bresenham_ algorithm.
---
---@param x number # the `coordinates` of the circle's center
---@param y number # the `coordinates` of the circle's center
---@param radius number # the radius of the circle in pixels
---@param color number # the index of the desired color in the current `palette`
function circ(x, y, radius, color) end

---
---Draws the circumference of a circle with its center at **x**, **y** using the **radius** and **color** requested.
---It uses the _Bresenham_ algorithm.
---
---@param x number # the `coordinates` of the circle's center
---@param y number # the `coordinates` of the circle's center
---@param radius number # the radius of the circle in pixels
---@param color number # the index of the desired color in the current `palette`
function circb(x, y, radius, color) end

---
---This function draws a filled ellipse of the radiuses **a** **b** and **color** with its center at **x**, **y**. It uses the _Bresenham_ algorithm.
---
---See also:
---
---- `ellib` - draw only the boundary of the ellipse
---
---@param x number # the `coordinates` of the ellipse's center
---@param y number # the `coordinates` of the ellipse's center
---@param a number # the horizontal radius of the ellipse in pixels
---@param b number # the vertical radius of the ellipse in pixels
---@param color number # the index of the desired color in the current `palette`
function elli(x, y, a, b, color) end

---
---This function draws an ellipse border with the radiuses **a** **b** and **color** with its center at **x**, **y**. It uses the _Bresenham_ algorithm.
---
---See also:
---
---- `elli` - draw a filled ellipse
---
---@param x number # the `coordinates` of the ellipse's center
---@param y number # the `coordinates` of the ellipse's center
---@param a number # the horizontal radius of the ellipse in pixels
---@param b number # the vertical radius of the ellipse in pixels
---@param color number # the index of the desired color in the current `palette`
function ellib(x, y, a, b, color) end

---
---This function limits drawing to a clipping region or 'viewport' defined by `x`,`y`, `width`, and `height`.
---Any pixels falling outside of this area will not be drawn.
---
---Calling `clip()` with no parameters will reset the drawing area to the entire screen.
---
---@param x number # `coordinates` of the top left of the clipping region
---@param y number # `coordinates` of the top left of the clipping region
---@param width number # width of the clipping region in pixels
---@param height number # height of the clipping region in pixels
function clip(x, y, width, height) end

---
---This function clears/fills the entire screen using **color**. If no parameter is passed, index 0 of the palette is used.
---
---The function is often called inside TIC(), clearing the screen before each frame, but this is not mandatory.  If you're drawing to the entire screen each frame (for example with sprites, the map or primitive shapes) there is no need to clear the screen beforehand.
---
---_Tip:_ You can create some interesting effects by not calling cls(), allowing frames to stack on top of each other - or using it repeatedly to "flash" the screen when some special event occurs.
---
---@param color? number # index (0..15) of a color in the current `palette` (defaults to 0)
function cls(color) end

---
---This function will draw text to the screen using the foreground spritesheet as the font. Sprite #256 is used for ASCII code 0, #257 for code 1 and so on. The character 'A' has the ASCII code 65 so will be drawn using the sprite with sprite #321 (256+65). See the example below or check out the [In-Browser Demo](https://tic80.com/play?cart=20)
---
---* To simply print text to the screen using the `system font`, please see `print`
---* To print to the console, please see `trace`
---
---@param text string # the string to be printed
---@param x number # `coordinates` of print position
---@param y number # `coordinates` of print position
---@param transcolor? number # the `palette` index to use for transparency
---@param char_width? number # distance between start of each character, in pixels
---@param char_height? number # distance vertically between start of each character, in pixels, when printing multi-line text.
---@param fixed? boolean # indicates whether the font is fixed width (defaults to false ie variable width)
---@param scale? number # font scaling (defaults to 1)
---@return number text_width # returns the width of the rendered text in pixels
function font(text, x, y, transcolor, char_width, char_height, fixed, scale) end

---
---Draws a straight line from point (x0,y0) to point (x1,y1) in the specified color.
---
---@param x0 number # the `coordinates` of the start of the line
---@param y0 number # the `coordinates` of the start of the line
---@param x1 number # the `coordinates` of the end of the line
---@param y1 number # the `coordinates` of the end of the line
---@param color number # the index of the color in the current `palette`
function line(x0, y0, x1, y1, color) end

---
---The map consists of cells of 8x8 pixels, each of which can be filled with a tile using the map editor.
---
---The map can be up to 240 cells wide by 136 deep. This function will draw the desired area of the map to a specified screen position. For example, `map(5,5,12,10,0,0)` will draw a 12x10 section of the map, starting from map co-ordinates (5,5) to screen position (0,0). `map()` without any parameters will draw a 30x17 map section (a full screen) to screen position (0,0).
---
---The map function’s last parameter is a powerful callback function for changing how each cells is drawn. It can be used to rotate, flip or even replace tiles entirely. Unlike `mset`, which saves changes to the map, this special function can be used to create animated tiles or replace them completely. Some examples include changing tiles to open doorways, hiding tiles used only to spawn objects in your game and even to emit the objects themselves.
---
---The tilemap is laid out sequentially in RAM - writing 1 to 0x08000 will cause tile #1 to appear at top left when `map` is called. To set the tile immediately below this we need to write to 0x08000 + 240, ie 0x080F0
---
---@param x? number # The coordinates of the top left map cell to be drawn. (default: 0)
---@param y? number # The coordinates of the top left map cell to be drawn. (default: 0)
---@param w? number # The number of cells to draw horizontally and vertically. (default: 30)
---@param h? number # The number of cells to draw horizontally and vertically. (default: 17)
---@param sx? number # The screen coordinates where drawing of the map section will start. (default: 0)
---@param sy? number # The screen coordinates where drawing of the map section will start. (default: 0)
---@param colorkey? number # index (or array of indexes 0.80.0) of the color that will be used as transparent color. Not setting this parameter will make the map opaque. (default: -1)
---@param scale? number # Map scaling. (default: 1)
---@param remap? function # An optional function called before every tile is drawn. Using this callback function you can show or hide tiles, create tile animations or flip/rotate tiles during the map rendering stage: `callback [tile [x y] ] -> [tile [flip [rotate] ] ]`
function map(x, y, w, h, sx, sy, colorkey, scale, remap) end

---
---This function can read or write individual pixel color values. When called with a **color** argument , the pixel at the specified `coordinates` is set to that color. When called with only **x y** arguments, the color of the pixel at the specified coordinates is returned.
---
---@param x number # `coordinates` of the pixel
---@param y number # `coordinates` of the pixel
---@param color number # the index (0-15) of the `palette` color at the specified `coordinates`.
---@return number color # the index (0-15) of the `palette` color at the specified `coordinates`.
function pix(x, y, color) end

---
---This will simply print text to the screen using the font defined in config. When set to true, the fixed width option ensures that each character will be printed in a 'box' of the same size, so the character 'i' will occupy the same width as the character 'w' for example. When fixed width is false, there will be a single space between each character. Refer to the example for an illustration.
---
---* To use a custom rastered font, check out `font`.
---* To print to the console, check out `trace`.
---
---@param text string # any string to be printed to the screen
---@param x? number # `coordinates` for printing the text (default: 0)
---@param y? number # `coordinates` for printing the text (default: 0)
---@param color? number # the `color` to use to draw the text to the screen (default: 15)
---@param fixed? boolean # a flag indicating whether fixed width printing is required (default: false)
---@param scale? number # font scaling (default: 1)
---@param smallfont? boolean # use small font if true (default: false)
---@return number text_width # returns the width of the text in pixels.
function print(text, x, y, color, fixed, scale, smallfont) end

---
---This function draws a filled rectangle at the specified position.
---
---See also:
---
---- `rectb` - draw only the border of the rectangle
---
---@param x number # `coordinates` of the top left corner of the rectangle
---@param y number # `coordinates` of the top left corner of the rectangle
---@param width number # the width the rectangle in pixels
---@param height number # the height of the rectangle in pixels
---@param color number # the index of the color in the `palette` that will be used to fill the rectangle
function rect(x, y, width, height, color) end

---
---This function draws a one pixel thick rectangle border.
---
---See also:
---
---- `rect` - draws a filled rectangle
---
---@param x number # `coordinates` of the top left corner of the rectangle
---@param y number # `coordinates` of the top left corner of the rectangle
---@param width number # the width the rectangle in pixels
---@param height number # the height of the rectangle in pixels
---@param color number # the index of the color in the `palette` that will be used to color the rectangle's border.
function rectb(x, y, width, height, color) end

---
---Draws the `sprite` number **index** at the **x** and **y** `coordinate`.
---
---You can specify a **colorkey** in the `palette` which will be used as the transparent color or use a value of -1 for an opaque sprite.
---
---The sprite can be **scaled** up by a desired factor. For example, a scale factor of 2 means an 8x8 pixel sprite is drawn to a 16x16 area of the screen.
---
---You can **flip** the sprite where:
---* 0 = No Flip
---* 1 = Flip horizontally
---* 2 = Flip vertically
---* 3 = Flip both vertically and horizontally
---
---When you **rotate** the sprite, it's rotated clockwise in 90° steps:
---* 0 = No rotation
---* 1 = 90° rotation
---* 2 = 180° rotation
---* 3 = 270° rotation
---
---You can draw a **composite** sprite (consisting of a rectangular region of sprites from the sprite sheet) by specifying the **w** and **h** parameters (which default to 1).
---
---@param id number # index of the `sprite` (0..511)
---@param x number # screen `coordinates` of top left corner of sprite.
---@param y number # screen `coordinates` of top left corner of sprite.
---@param colorkey? number # index (or array of indexes) of the color in the `sprite` that will be used as transparent color.  Use -1 if you want an opaque sprite. (default: -1)
---@param scale? number # scale factor applied  to `sprite`. (default: 1)
---@param flip? number # flip the `sprite` vertically or horizontally or both. (default: 0)
---@param rotate? number # rotate the `sprite` by 0, 90, 180 or 270 degrees. (default: 0)
---@param w? number # width of composite sprite (default: 1)
---@param h? number # height of composite sprite (default: 1)
function spr(id, x, y, colorkey, scale, flip, rotate, w, h) end

---
---This function draws a triangle filled with **color**, using the supplied vertices.
---
---@param x1 number # the `coordinates` of the first triangle corner
---@param y1 number # the `coordinates` of the first triangle corner
---@param x2 number # the coordinates of the second corner
---@param y2 number # the coordinates of the second corner
---@param x3 number # the coordinates of the third corner
---@param y3 number # the coordinates of the third corner
---@param color number # the index of the desired color in the current `palette`
function tri(x1, y1, x2, y2, x3, y3, color) end

---
---This function draws a triangle border with **color**, using the supplied vertice
---
---@param x1 number # the `coordinates` of the first triangle corner
---@param y1 number # the `coordinates` of the first triangle corner
---@param x2 number # the coordinates of the second corner
---@param y2 number # the coordinates of the second corner
---@param x3 number # the coordinates of the third corner
---@param y3 number # the coordinates of the third corner
---@param color number # the index of the desired color in the current `palette`
function trib(x1, y1, x2, y2, x3, y3, color) end

---
---This function draws a triangle filled with texture from either `SPRITES` or `MAP` `RAM`.
---
---@param x1 number # the screen `coordinates` of the first corner
---@param y1 number # the screen `coordinates` of the first corner
---@param x2 number # the screen coordinates of the second corner
---@param y2 number # the screen coordinates of the second corner
---@param x3 number # the screen coordinates of the third corner
---@param y3 number # the screen coordinates of the third corner
---@param u1 number # the UV coordinates of the first corner
---@param v1 number # the UV coordinates of the first corner
---@param u2 number # the UV coordinates of the second corner
---@param v2 number # the UV coordinates of the second corner
---@param u3 number # the UV coordinates of the third corner
---@param v3 number # the UV coordinates of the third corner
---@param use_map? boolean # if false (default), the triangle's texture is read from `SPRITES` RAM. If true, the texture comes from the `MAP` RAM.
---@param trans? number # index (or array of indexes 0.80) of the color(s) that will be used as transparent (default: -1)
function textri(x1, y1, x2, y2, x3, y3, u1, v1, u2, v2, u3, v3, use_map, trans) end

