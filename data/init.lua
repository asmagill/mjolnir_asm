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
--- Functions for data encoding and decoding within Mjolnir.
---
--- json, uuid, and clipboard code is based on code from the previous incarnation of Mjolnir by
--- [Steven Degutis](https://github.com/sdegutis/).
---
--- utf-8 code is based upon the Lua 5.3 alpha specification (http://www.lua.org)

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

-- Return Module Object --------------------------------------------------

return module



