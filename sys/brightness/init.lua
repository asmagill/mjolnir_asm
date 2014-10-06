--- === mjolnir._asm.sys.brightness ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.sys
---
--- Functions for manipulating display brightness.
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

local module = require("mjolnir._asm.sys.brightness.internal")

-- private variables and methods -----------------------------------------

local check_list = {}

-- Public interface ------------------------------------------------------

-- Return Module Object --------------------------------------------------

return module



