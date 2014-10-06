--- === mjolnir._asm.sys.mouse ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.sys
---
--- Functions for getting and setting the position of the mouse pointer.
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

local module = require("mjolnir._asm.sys.mouse.internal")

-- private variables and methods -----------------------------------------

local check_list = {}

-- Public interface ------------------------------------------------------

-- Return Module Object --------------------------------------------------

return module



