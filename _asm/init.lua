local module = {
--[=[
    _NAME        = 'mjolnir._asm',
    _VERSION     = 'the 1st digit of Pi/0',
    _URL         = 'https://github.com/asmagill/mjolnir_asm._asm',
    _LICENSE     = [[ See README.md ]]
    _DESCRIPTION = [[

--- === mjolnir._asm ===
---
--- Home: https://github.com/asmagill/mjolnir_asm._asm
---
--- Shared functions for mjolnir._asm modules

    ]],
--]=]
}

local mjolnir_mod_name = "mjolnir._asm"
local c_library = "internal"

-- integration with C functions ------------------------------------------

if c_library then
	for i,v in pairs(require(mjolnir_mod_name.."."..c_library)) do module[i] = v end
end

-- private variables and methods -----------------------------------------

-- Public interface ------------------------------------------------------

-- Return Module Object --------------------------------------------------

return module



