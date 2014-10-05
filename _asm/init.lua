--- === mjolnir._asm ===
---
--- Home: https://github.com/asmagill/mjolnir_asm._asm
---
--- Shared functions for mjolnir._asm modules
---
--- At present this module does not provide any direct functionality which can be included in your Lua scripts, but it does contain C functions which are used in other modules and are contained here for easy maintenance and bug fixes.  I will provide further documentation at a later date, but unless you're coding your own modules and linking external libraries, you don't need to worry about this module -- it will be installed if another module requires it and the necessary functions will be loaded only when required.
---

local module = require("mjolnir._asm.internal")

-- private variables and methods -----------------------------------------

-- Public interface ------------------------------------------------------

-- Return Module Object --------------------------------------------------

return module



