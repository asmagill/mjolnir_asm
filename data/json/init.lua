--- === mjolnir._asm.data.json ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.data
---
--- This module provides JSON encoding and decoding for Mjolnir utilizing the NSJSONSerialization functions available in OS X 10.7 +
---
--- This module is based partially on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).
---
--- This module also requires [mjolnir._asm](https://github.com/asmagill/mjolnir_asm) for NSObject traversal.

require("mjolnir._asm")

local mjolnir_mod_name = "mjolnir._asm.data.json.internal"
local module = require(mjolnir_mod_name)

-- private variables and methods -----------------------------------------

-- Public interface ------------------------------------------------------

-- Return Module Object --------------------------------------------------

return module
