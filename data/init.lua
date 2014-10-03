--- === mjolnir._asm.data ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.data
---
--- Functions for data encoding and decoding data within Mjolnir.  This module contains a variety of modules that were separated in Hydra, but seemed too small/somewhat related enough that combining them seemed reasonable.
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

local mjolnir_mod_name = "mjolnir._asm.data.internal"
local module = require(mjolnir_mod_name)

-- private variables and methods -----------------------------------------

-- Public interface ------------------------------------------------------

--- mjolnir._asm.data.applekeys[...]
--- Variable
--- Array of symbols representing special keys in the mac environment, as per http://macbiblioblog.blogspot.com/2005/05/special-key-symbols.html.
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

--- mjolnir._asm.data.hexdump(string [, count]) -> string
--- Function
--- Treats the input string as a binary blob and returns a prettied up hex dump of it's contents. By default, a newline character is inserted after every 16 bytes, though this can be changed by also providing the optional count argument.
module.hexdump = function(stuff, linemax)
	local ascii = ""
	local count = 0
	local linemax = tonumber(linemax) or 16
	local buffer = ""
	local rb = ""
	local offset = math.floor(math.log(#stuff,16)) + 1
	offset = offset + (offset % 2)

	local formatstr = "%0"..tostring(offset).."x : %-"..tostring(linemax * 3).."s : %s"

	for c in string.gmatch(tostring(stuff), ".") do
		buffer = buffer..string.format("%02X ",string.byte(c))
		-- using string.gsub(c,"%c",".") didn't work in mjolnir, but
		-- I didn't dig any deeper -- this works.
		if string.byte(c) < 32 or string.byte(c) > 126 then
		    ascii = ascii.."."
		else
		    ascii = ascii..c
		end
		count = count + 1
		if count % linemax == 0 then
			rb = rb .. string.format(formatstr, count - linemax, buffer, ascii) .. "\n"
			buffer=""
			ascii=""
		end
	end
	if count % linemax ~= 0 then
		rb = rb .. string.format(formatstr, count - (count % linemax), buffer, ascii) .. "\n"
	end
	return rb
end


-- Return Module Object --------------------------------------------------

return module



