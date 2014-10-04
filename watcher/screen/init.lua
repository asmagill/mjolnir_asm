--- === mjolnir._asm.watcher.screen ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.watcher
---
--- Watch for screen layout changes in Mjolnir.
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

local module = require("mjolnir._asm.watcher.screen.internal")

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

--- mjolnir._asm.watcher.screen.new(fn) -> watcher
--- Constructor
--- Creates a new screen-watcher that can be started; fn will be called when your screen layout changes in any way, whether by adding/removing/moving
function module.new(fn)
  local _fn = wrap(fn)
  local t = module._new(_fn)
  return t
end

-- Return Module Object --------------------------------------------------

return module
