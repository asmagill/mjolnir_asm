--- === mjolnir._asm.eventtap.event ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.eventtap.event
---
--- Functionality to inspect, modify, and create events for `mjolnir_asm.eventtap` is provided by this module.
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).
local module = require("mjolnir._asm.eventtap.event.internal")

-- private variables and methods -----------------------------------------

-- Public interface ------------------------------------------------------

if not mjolnir.keycodes then mjolnir.keycodes = require("mjolnir.keycodes") end

-- Allow for reverse lookups as well...
local types_reverse, properties_reverse = {}, {}

for i,v in pairs(module.types) do types_reverse[v] = i end
for i,v in pairs(types_reverse) do module.types[i] = v end

for i,v in pairs(module.properties) do properties_reverse[v] = i end
for i,v in pairs(properties_reverse) do module.properties[i] = v end

-- Return Module Object --------------------------------------------------

return module
