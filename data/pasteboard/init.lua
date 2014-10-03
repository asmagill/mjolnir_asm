--- === mjolnir._asm.data.pasteboard ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.data
---
--- This is a module provides access to the OS X clipboard from within Mjolnir
---
--- This module is based partially on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).


require("mjolnir._asm")

local mjolnir_mod_name = "mjolnir._asm.data.pasteboard.internal"
local module = require(mjolnir_mod_name)

-- private variables and methods -----------------------------------------

-- Public interface ------------------------------------------------------

-- Return Module Object --------------------------------------------------

return module
