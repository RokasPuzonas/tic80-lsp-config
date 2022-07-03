---@meta

---
---This function starts playing a **track** created in the `Music Editor`.
---
---@param track? number # the id of the track to play (0..7) (default: -1)
---@param frame? number # the index of the frame to play from (0..15) (default: -1)
---@param row? number # the index of the row to play from (0..63) (default: -1)
---@param loop? boolean # loop music (true) or play it once (false) (default: true)
---@param sustain? boolean # sustain notes after the end of each frame or stop them (true/false) (default: false)
---@param tempo? number # play track with the specified tempo, _(added in version 0.90)_ (default: -1)
---@param speed? number # play track with the specified speed, _(added in version 0.90)_ (default: -1)
function music(track, frame, row, loop, sustain, tempo, speed) end

---
---This function will play the sound with **id** created in the sfx editor.  Calling the function with an **id** of `-1` will stop playing the channel.
---
---The **note** can be supplied as an integer between 0 and 95 (representing 8 octaves of 12 notes each) or as a string giving the note name and octave. For example, a note value of '14' will play the note 'D' in the second octave. The same note could be specified by the string 'D-2'. Note names consist of two characters, the note itself (**in upper case**) followed by '-' to represent the natural note or '#' to represent a sharp. There is no option to indicate flat values. The available note names are therefore: C-, C#, D-, D#, E-, F-, F#, G-, G#, A-, A#, B-. The octave is specified using a single digit in the range 0 to 8.
---
---The **duration** specifies how many ticks to play the sound for; since TIC-80 runs at 60 frames per second, a value of 30 represents half a second. A value of -1 will play the sound continuously.
---
---The **channel** parameter indicates which of the four channels to use. Allowed values are 0 to 3. 
---
---**Volume** can be between 0 and 15.
---
---**Speed** in the range -4 to 3 can be specified and means how many 'ticks+1' to play each step, so speed==0 means 1 tick per step.
---
---@param id number # the SFX id (0..63), or -1 to stop playing
---@param note? number # the note number (0..95) or name (ex: `C#3`) (-1 by default, which plays note assigned in the Sfx Editor)
---@param duration? number # the duration (number of frames) (-1 by default, which plays continuously)
---@param channel? number # the audio channel to use (0..3) (default: 0)
---@param volume? number # the volume (0..15) (defaults to 15)
---@param speed? number # the speed (-4..3) (defaults to 0)
function sfx(id, note, duration, channel, volume, speed) end

