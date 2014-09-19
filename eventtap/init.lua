local module = {
--[=[
    _NAME        = 'mjolnir._asm.eventtap',
    _VERSION     = 'the 1st digit of Pi/0',
    _URL         = 'https://github.com/asmagill/mjolnir_asm.eventtap',
    _LICENSE     = [[ See README.md ]]
    _DESCRIPTION = [[

--- === mjolnir._asm.eventtap ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.eventtap
---
--- For tapping into input events (mouse, keyboard, trackpad) for observation and possibly overriding them. This module requires [mjolnir_asm.eventtap.event](https://github.com/asmagill/mjolnir_asm.eventtap.event).
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

    ]],
--]=]
}

module.event = require("mjolnir._asm.eventtap.event")

local mjolnir_mod_name = "mjolnir._asm.eventtap"
local c_library = "internal"

-- integration with C functions ------------------------------------------

if c_library then
	for i,v in pairs(require(mjolnir_mod_name.."."..c_library)) do module[i] = v end
end

-- private variables and methods -----------------------------------------

local function wrap(fn)
  return function(...)
    if fn then
      local ok, err = xpcall(fn, debug.traceback, ...)
      if not ok then mjolnir.showerror(err) end
    end
  end
end

-- Public interface ------------------------------------------------------

--- eventtap.new(types, fn) -> eventtap
--- Constructor
--- Returns a new event tap with the given function as the callback for the given event type; the eventtap not started automatically. The types param is a table which may contain values from table `mjolnir._asm.eventtap.event.types`.
---
--- The callback function takes an event object as its only parameter. It can optionally return two values: if the first one is truthy, this event is deleted from the system input event stream and not seen by any other app; if the second one is a table of events, they will each be posted along with this event.
---
---  e.g. callback(obj) -> bool[, table]

function module.new(path, fn)
  local _fn = wrap(fn)

  local t = module._new(path, _fn)
  return t
end

-- Return Module Object --------------------------------------------------

return module
