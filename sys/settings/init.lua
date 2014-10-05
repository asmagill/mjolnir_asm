local module = {
--[=[
    _NAME        = 'mjolnir._asm.settings',
    _VERSION     = 'the 1st digit of Pi/0',
    _URL         = 'https://github.com/asmagill/mjolnir_asm.timer',
    _LICENSE     = [[ See README.md ]]
    _DESCRIPTION = [[

--- === mjolnir._asm.settings ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.settings
---
--- Functions for manipulating user defaults for the Mjolnir application, allowing for the creation of user-defined settings which persist across Mjolnir launches and reloads.  Settings must have a string key and must be made up of serializable Lua objects (string, number, boolean, nil, tables of such, etc.)
---
--- This module is based partially on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).
---
--- This module also requires [mjolnir._asm](https://github.com/asmagill/mjolnir_asm) for NSObject traversal.

    ]],
--]=]
}

require("mjolnir._asm")

local mjolnir_mod_name = "mjolnir._asm.settings"
local c_library = "internal"

-- integration with C functions ------------------------------------------

--if c_library then
--	for i,v in pairs(require(mjolnir_mod_name.."."..c_library)) do module[i] = v end
--end

module = require(mjolnir_mod_name.."."..c_library)

-- private variables and methods -----------------------------------------

-- Public interface ------------------------------------------------------

-- Return Module Object --------------------------------------------------

return module



