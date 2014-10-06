--- === mjolnir._asm.undocumented.cgsdebug ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.undocumented
---
--- Functions to get and set undocumented options and features within OS X.  These are undocumented features from the "private" api's for Mac OS X and are not guaranteed to work with any particular version of OS X or at all.  This code was based primarily on code samples and segments found at (https://code.google.com/p/undocumented-goodness/) and (https://code.google.com/p/iterm2/source/browse/branches/0.10.x/CGSInternal/CGSDebug.h?r=2).
---
--- This submodule provides access to CGSDebug related features.  Most notably, this contains the hydra.shadow(bool) functionality, and a specific function is provided for just that functionality.
---
--- I make no promises that these will work for you or work at all with any, past, current, or future versions of OS X.  I can confirm only that they didn't crash my machine during testing under 10.10pb2. You have been warned.

local module = require("mjolnir._asm.undocumented.cgsdebug.internal")

-- private variables and methods -----------------------------------------

-- Public interface ------------------------------------------------------

local options_reverse = {}

for i,v in pairs(module.options) do options_reverse[v] = i end
for i,v in pairs(options_reverse) do module.options[i] = v end

-- Return Module Object --------------------------------------------------

return module



