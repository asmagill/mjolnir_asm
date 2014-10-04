--- === mjolnir._asm.watcher.battery ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.watcher
---
--- Functions for watching battery state changes.
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

local module = require("mjolnir._asm.watcher.battery.internal")

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

--- mjolnir._asm.watcher.battery.new(fn) -> watcher
--- Constructor
--- Creates a battery watcher that can be started. When started, fn will be called each time a battery attribute changes.
function module.new(battery, fn)
  local _fn = wrap(fn)
  local t = module._new(battery, _fn)
  return t
end

-- Return Module Object --------------------------------------------------

return module



