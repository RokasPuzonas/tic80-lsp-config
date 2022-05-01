---@meta

---
---This function allows you to read the status of TIC's controller buttons. It returns `true` if the button with the supplied **id** is currently in the pressed state and remains `true` for as long as the button is held down. To see if a button was _just_ pressed, use `btnp` instead.
---
---@param id? number # id (0..31) of the key we want to interrogate (see the `key map` for reference)
---@return boolean pressed # button is pressed (true/false)
function btn(id) end

---
---This function allows you to read the status of one of TIC's buttons. It returns `true` only if the key has been pressed since the last frame.
---
---You can also use the optional **hold** and **period** parameters which allow you to check if a button is being held down. After the time specified by **hold** has elapsed, btnp will return *true* each time **period** is passed if the key is still down. For example, to re-examine the state of button '0' after 2 seconds and continue to check its state every 1/10th of a second, you would use btnp(0, 120, 6). Since time is expressed in ticks and TIC runs at 60 frames per second, we use the value of 120 to wait 2 seconds and 6 ticks (ie 60/10) as the interval for re-checking.
---
---@param id? number # the id (0..31) of the button we wish to interrogate - see the `key map` for reference
---@param hold? number # the time (in ticks) the button must be pressed before re-checking
---@param period? number # the amount of time (in ticks) after **hold** before this function will return `true` again.
---@return boolean pressed # button is pressed now but not in previous frame (true/false)
function btnp(id, hold, period) end

---
---The function returns *true* if the key denoted by *keycode* is presse
---
---@param code? number # the key code we want to check (1..65)
---@return boolean pressed # key is currently pressed (true/false)
function key(code) end

---
---This function returns `true` if the given key is pressed but wasn't pressed in the previous frame. Refer to `btnp` for an explanation of the optional **hold** and **period** parameters
---
---@param code? number # the key code we want to check (1..65) (see codes [here](https://github.com/nesbox/TIC-80/wiki/key#parameters))
---@param hold? number # time in ticks before autorepeat
---@param period? number # time in ticks for autorepeat interval
---@return boolean pressed # key is pressed (true/false)
function keyp(code, hold, period) end

---
---This function returns the mouse coordinates and a boolean value for the state of each mouse button, with true indicating that a button is pressed.
---
---@return number x # `coordinates` of the mouse pointer
---@return number y # `coordinates` of the mouse pointer
---@return boolean left # left button is down (true/false)
---@return boolean middle # middle button is down (true/false)
---@return boolean right # right button is down (true/false)
---@return number scrollx # x scroll delta since last frame (-31..32)
---@return number scrolly # y scroll delta since last frame (-31..32)
function mouse() end

