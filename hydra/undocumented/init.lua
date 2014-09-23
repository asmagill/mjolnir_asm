local module = {
--[=[
    _NAME        = 'mjolnir._asm.undocumented.spaces',
    _VERSION     = 'the 1st digit of Pi/0',
    _URL         = 'https://github.com/asmagill/mjolnir_asm.hydra',
    _LICENSE     = [[ See README.md ]]
    _DESCRIPTION = [[

--- === mjolnir._asm.hydra.undocumented ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.hydra
---
--- This module provides the functionality, as it was in Hydra, for `spaces` and `hydra.setosxshadows`.  As these functions use undocumented APIs, they are grouped together here.
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

    ]],
--]=]
}

local mjolnir_mod_name = "mjolnir._asm.hydra.undocumented"
local c_library = "internal"

-- integration with C functions ------------------------------------------

if c_library then
	for i,v in pairs(require(mjolnir_mod_name.."."..c_library)) do module[i] = v end
end

-- private variables and methods -----------------------------------------

-- Public interface ------------------------------------------------------

--- mjolnir._asm.hydra.undocumented.spaces
--- Variable
--- Convenience module `spaces` containing just the Hydra spaces modules for Mjolnir with simplified names.
---
--- e.g.
--- <pre>
---      spaces = require("mjolnir._asm.hydra.undocumented").spaces
---
---      spaces.count()         -- see spaces_count()
---      spaces.currentspace()  -- see spaces_currentspace()
---      spaces.movetospace(#)  -- see spaces_movetospace(#)
---</pre>
---
module.spaces = {
    count = module.spaces_count,
    currentspace = module.spaces_currentspace,
    movetospace = module.spaces_movetospace,
}

-- Return Module Object --------------------------------------------------

return module



