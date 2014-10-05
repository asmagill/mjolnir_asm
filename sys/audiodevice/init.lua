--- === mjolnir._asm.sys.audiodevice ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.sys
---
--- Manipulate the system's audio devices.
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

local module = require("mjolnir._asm.sys.audiodevice.internal")

-- private variables and methods -----------------------------------------

-- Public interface ------------------------------------------------------

--- mjolnir._asm.sys.audiodevice.current() -> table
--- Function
--- Convenience function which returns a table with the following keys and values:
--- ~~~lua
---     {
---         name = defaultoutputdevice():name(),
---         muted = defaultoutputdevice():muted(),
---         volume = defaultoutputdevice():volume(),
---         device = defaultoutputdevice(),
---     }
--- ~~~
module.current = function()
    return {
        name = module.defaultoutputdevice():name(),
        muted = module.defaultoutputdevice():muted(),
        volume = module.defaultoutputdevice():volume(),
        device = module.defaultoutputdevice(),
    }
end
-- Return Module Object --------------------------------------------------

return module



