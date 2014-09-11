local module = {
--[=[
    _NAME        = 'mjolnir._asm.timer',
    _VERSION     = 'the 1st digit of Pi/0',
    _URL         = 'https://github.com/asmagill/mjolnir_asm.timer',
    _LICENSE     = [[ See README.md ]]
    _DESCRIPTION = [[
    
--- === mjolnir._asm.settings ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.settings
---
--- Functions for user-defined settings that persist across Hydra launches.
---
--- This module is based on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

    ]],
--]=]
}

local mjolnir_mod_name = "mjolnir._asm.settings"
local c_library = "internal"

-- integration with C functions ------------------------------------------

if c_library then
	for i,v in pairs(require(mjolnir_mod_name.."."..c_library)) do module[i] = v end
end

-- private variables and methods -----------------------------------------

-- Public interface ------------------------------------------------------

-- Return Module Object --------------------------------------------------

return module


