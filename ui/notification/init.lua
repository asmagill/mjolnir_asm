--- === mjolnir._asm.ui.notification ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.ui
---
--- Apple's built-in notifications system.
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

local module = require("mjolnir._asm.ui.notification.internal")

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

--- mjolnir._asm.ui.notification.new(title, subtitle, information, fn)
--- Function
--- Returns a new notification object with the specified information and the assigned callback function.
module.new = function(title, subtitle, information, fn)
    return module._new(title, subtitle, information, wrap(fn))
end

-- Return Module Object --------------------------------------------------

return module

