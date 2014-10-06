--- === mjolnir._asm.notify ===
---
--- Home: https://github.com/asmagill/mjolnir_asm._asm
---
--- Apple's built-in notifications system.
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

local module = require("mjolnir._asm.notify.internal")

-- private variables and methods -----------------------------------------

local function callback(tag)
  for k, v in pairs(module.registry) do
    if k ~= "n" and v ~= nil then
      local fntag, fn = v[1], v[2]
      if tag == fntag then
        fn()
      end
    end
  end
end

local function wrap(fn)
  return function(...)
    if fn then
      local ok, err = xpcall(fn, debug.traceback, ...)
      if not ok then mjolnir.showerror(err) end
    end
  end
end


-- Public interface ------------------------------------------------------

--- mjolnir._asm.notify.registry[]
--- Variable
--- This table contains the list of registered tags and their functions.  It should not be modified directly, but instead by the mjolnir._asm.notify.register(tag, fn) and mjolnir._asm.notify.unregister(id) functions.
module.registry = {}
module.registry.n = 0

setmetatable(module.registry, { __gc = module.withdraw_all })

if not _notifysetup then
  module._setup(callback)
  _notifysetup = true
end

--- mjolnir._asm.notify.register(tag, fn) -> id
--- Function
--- Registers a function to be called when an Apple notification with the given tag is clicked.
module.register = function(tag, fn)
  local id = module.registry.n + 1
  module.registry[id] = {tag, wrap(fn)}
  module.registry.n = id
  return id
end

--- mjolnir._asm.notify.unregister(id)
--- Function
--- Unregisters a function to no longer be called when an Apple notification with the given tag is clicked.
module.unregister = function(id)
  module.registry[id] = nil
end

--- mjolnir._asm.notify.unregisterall()
--- Function
--- Unregisters all functions registered for notification-clicks; called automatically when user config reloads.
module.unregisterall = function()
  module.registry = {}
  module.registry.n = 0
end

-- Return Module Object --------------------------------------------------

return module

