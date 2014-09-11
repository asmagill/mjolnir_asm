local module = {
--[=[
    _NAME        = 'mjolnir._asm.data',
    _VERSION     = 'the 1st digit of Pi/0',
    _URL         = 'https://github.com/asmagill/mjolnir_asm.data',
    _LICENSE     = [[ See README.md ]]
    _DESCRIPTION = [[
    
--- === mjolnir._asm.settings ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.data
---
--- Functions for data encoding and decoding data within Mjolnir.  This module contains a variety
--- of modules that were separated in Hydra, but seemed too small/somewhat related enough that
--- combining them seemed reasonable.
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by
--- [Steven Degutis](https://github.com/sdegutis/).

    ]],
--]=]
}

local mjolnir_mod_name = "mjolnir._asm.data"
local c_library = "internal"

-- integration with C functions ------------------------------------------

if c_library then
	for i,v in pairs(require(mjolnir_mod_name.."."..c_library)) do module[i] = v end
end

-- private variables and methods -----------------------------------------

-- Public interface ------------------------------------------------------

--- mjolnir._asm.data.applekeys[...]
--- Variable
--- Array of symbols representing special keys in the mac environment, as per
--- http://macbiblioblog.blogspot.com/2005/05/special-key-symbols.html.
module.applekeys = {
    ["escape"] = "⎋",
    ["tab"] = "⇥",
    ["backtab"] = "⇤",
    ["capslock"] = "⇪",
    ["shift"] = "⇧",
    ["ctrl"] = "⌃",
    ["alt"] = "⌥",
    ["option"] = "⌥",
    ["apple"] = "",
    ["cmd"] = "⌘",
    ["space"] = "␣",
    ["return"] = "⏎",
    ["return2"] = "↩",
    ["delete"] = "⌫",
    ["forwarddelete"] = "⌦",
    ["help"] = "﹖",
    ["home"] = "⇱",
    ["home alternate2"] = "↖",
    ["home alternate3"] = "↸",
    ["end"] = "⇲",
    ["end2"] = "↘",
    ["pageup"] = "⇞",
    ["pagedown"] = "⇟",
    ["up"] = "↑",
    ["up2"] = "⇡",
    ["down"] = "↓",
    ["down2"] = "⇣",
    ["left"] = "←",
    ["left2"] = "⇠",
    ["right"] = "→",
    ["right2"] = "⇢",
    ["padclear"] = "⌧",
    ["numlock"] = "⇭",
    ["padenter"] = "⌤", -- apple preferred
    ["padenter2"] = "⎆", -- sun preferred
    ["padenter3"] = "↩",
    ["eject"] = "⏏",
    ["power"] = "⌽",
}

-- Return Module Object --------------------------------------------------

return module



