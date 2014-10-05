--- === mjolnir._asm.undocumented.bluetooth ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.undocumented
---
--- Functions to get and set undocumented options and features within OS X.  These are undocumented features from the "private" api's for Mac OS X and are not guaranteed to work with any particular version of OS X or at all.  This code was based primarily on code samples and segments found at https://github.com/toy/blueutil.
---
--- This submodule provides access to Bluetooth power and discoverability states, and the ability to change them.
---
--- I make no promises that these will work for you or work at all with any, past, current, or future versions of OS X.  I can confirm only that they didn't crash my machine during testing under 10.10pb2. You have been warned.

local module = require("mjolnir._asm.undocumented.bluetooth.internal")

-- private variables and methods -----------------------------------------

-- Public interface ------------------------------------------------------

-- Return Module Object --------------------------------------------------

return module



