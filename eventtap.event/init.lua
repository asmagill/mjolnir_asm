local module = {
--[=[
    _NAME        = 'mjolnir._asm.eventtap.event',
    _VERSION     = 'the 1st digit of Pi/0',
    _URL         = 'https://github.com/asmagill/mjolnir_asm.eventtap.event',
    _LICENSE     = [[ See README.md ]]
    _DESCRIPTION = [[

--- === mjolnir._asm.eventtap.event ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.eventtap.event
---
--- Functionality to inspect, modify, and create events for [mjolnir_asm.eventtap](https://github.com/asmagill/mjolnir_asm/eventtap) is provided by this module.
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

    ]],
--]=]
}

local mjolnir_mod_name = "mjolnir._asm.eventtap.event"
local c_library = "internal"

-- integration with C functions ------------------------------------------

if c_library then
	for i,v in pairs(require(mjolnir_mod_name.."."..c_library)) do module[i] = v end
end

-- private variables and methods -----------------------------------------

-- Public interface ------------------------------------------------------

-- Allow for reverse lookups as well...
local types_reverse, properties_reverse = {}, {}

for i,v in pairs(module.types) do types_reverse[v] = i end
for i,v in pairs(types_reverse) do module.types[i] = v end

for i,v in pairs(module.properties) do properties_reverse[v] = i end
for i,v in pairs(properties_reverse) do module.properties[i] = v end

-- Return Module Object --------------------------------------------------

return module
