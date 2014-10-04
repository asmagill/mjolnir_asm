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

--- mjolnir._asm.eventtap.new(types, fn) -> eventtap
--- Constructor
--- Returns a new event tap with the given function as the callback for the given event types; the eventtap not started automatically. The types param is a table which may contain values from table `mjolnir._asm.eventtap.event.types`. The event types are specified as bit-fields and are exclusively-or'ed together (see {"all"} below for why this is done.  This means { ...keyup, ...keydown, ...keyup }  is equivalent to { ...keydown }.
---
--- The callback function takes an event object as its only parameter. It can optionally return two values: if the first one is truthy, this event is deleted from the system input event stream and not seen by any other app; if the second one is a table of events, they will each be posted along with this event.
---
---  e.g. callback(obj) -> bool[, table]
---
--- If you specify the argument `types` as the special table {"all"[, events to ignore]}, then *all* events (except those you optionally list *after* the "all" string) will trigger a callback, even events which are not defined in the [Quartz Event Reference](https://developer.apple.com/library/mac/documentation/Carbon/Reference/QuartzEventServicesRef/Reference/reference.html). The value or usefulness of these events is uncertain at this time, but perhaps a more knowledgable member of the Mjolnir community may be able to provide additional references or make something of these other events. (Event type 14, for example, *appears* to be an event posted as focus leaves the current application and then again as it enters another application, but **you have been warned** that this is merely conjecture at this point and has not been verified or tested thoroughly!)
function module.new(path, fn)
  local _fn = wrap(fn)

  local t = module._new(path, _fn)
  return t
end

-- Return Module Object --------------------------------------------------

return module
