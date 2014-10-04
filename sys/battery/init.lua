--- === mjolnir._asm.sys.battery ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.sys
---
--- Functions for getting battery info. All functions here may return nil, if the information requested is not available.
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

require("mjolnir._asm")
local module = require("mjolnir._asm.sys.battery.internal")

-- private variables and methods -----------------------------------------

local check_list = {}
for i,v in pairs(module) do check_list[#check_list + 1] = i end

-- Public interface ------------------------------------------------------

--- mjolnir._asm.sys.battery.get_all() -> table
--- Function
--- Iterates through all informational functions defined in this module and returns a table containing the current information.  Useful if you want more than one piece of information at a given time.
module.get_all = function()
    local t = {}

    for i, v in ipairs(check_list) do
        t[v] = module[v]()
        if t[v] == nil then t[v] = "n/a" end
    end

    return t
end

-- Return Module Object --------------------------------------------------

return module



