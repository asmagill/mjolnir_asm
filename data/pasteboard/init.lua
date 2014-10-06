--- === mjolnir._asm.data.pasteboard ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.data
---
--- This is a module provides access to the OS X clipboard from within Mjolnir
---
--- This module is based partially on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).


local module = require("mjolnir._asm.data.pasteboard.internal")

-- private variables and methods -----------------------------------------

-- Public interface ------------------------------------------------------

-- Return Module Object --------------------------------------------------

return module
