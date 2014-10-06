--- === mjolnir._asm.data.json ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.data
---
--- This module provides JSON encoding and decoding for Mjolnir utilizing the NSJSONSerialization functions available in OS X 10.7 +
---
--- This module is based partially on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).
---
--- This module also requires `mjolnir._asm` for NSObject traversal.

require("mjolnir._asm")

local module = require("mjolnir._asm.data.json.internal")

-- private variables and methods -----------------------------------------

-- Public interface ------------------------------------------------------

-- Return Module Object --------------------------------------------------

return module
