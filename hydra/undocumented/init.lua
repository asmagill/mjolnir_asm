--- === mjolnir._asm.hydra.undocumented ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.hydra
---
--- This module provides the functionality, as it was in Hydra, for `spaces` and `hydra.setosxshadows`.  As these functions use undocumented APIs, they are grouped together here.
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

local module = require("mjolnir._asm.hydra.undocumented.internal")

-- private variables and methods -----------------------------------------

-- Public interface ------------------------------------------------------

--- mjolnir._asm.hydra.undocumented.spaces
--- Variable
--- Convenience module `spaces` containing just the Hydra spaces modules for Mjolnir with simplified names.
---
--- e.g.
--- ~~~lua
---      spaces = require("mjolnir._asm.hydra.undocumented").spaces
---
---      spaces.count()         -- see spaces_count()
---      spaces.currentspace()  -- see spaces_currentspace()
---      spaces.movetospace(#)  -- see spaces_movetospace(#)
--- ~~~
---
module.spaces = {
    count = module.spaces_count,
    currentspace = module.spaces_currentspace,
    movetospace = module.spaces_movetospace,
}

-- Return Module Object --------------------------------------------------

return module



