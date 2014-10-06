--- === mjolnir._asm.settings ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.sys
---
--- Functions for manipulating user defaults for the Mjolnir application, allowing for the creation of user-defined settings which persist across Mjolnir launches and reloads.  Settings must have a string key and must be made up of serializable Lua objects (string, number, boolean, nil, tables of such, etc.)
---
--- This module is based partially on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).
---
--- This module also requires `mjolnir._asm` for NSObject traversal.

require("mjolnir._asm")
local module = require("mjolnir._asm.settings.internal")

-- private variables and methods -----------------------------------------

-- Public interface ------------------------------------------------------

-- Return Module Object --------------------------------------------------

return module



