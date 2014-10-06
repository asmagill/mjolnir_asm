--- === mjolnir._asm.applistener ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.applistener
---
--- Listen to notifications sent by other apps.
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).
local module = require("mjolnir._asm.applistener.internal")

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

--- mjolnir._asm.applistener.new(fn(name, object, userinfo)) -> applistener
--- Constructor
--- Registers a listener function for inter-app notifications.
function module.new(fn)
  local _fn = wrap(fn)

  local t = module._new(_fn)
  return t
end

-- Return Module Object --------------------------------------------------

return module

