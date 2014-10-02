local module = {
--[=[
    _NAME        = 'mjolnir._asm.modal_hotkey',
    _VERSION     = 'the 1st digit of Pi/0',
    _URL         = 'https://github.com/asmagill/mjolnir_asm.modal_hotkey',
    _LICENSE     = [[ See README.md ]]
    _DESCRIPTION = [[

--- === mjolnir._asm.modal_hotkey ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.modal_hotkey
---
--- This module extends mjolnir.hotkey for conveniently binding modal hotkeys in the same manner as in Hydra.
---
--- Example usage:
---
---     k = modal_hotkey.new({"cmd", "shift"}, "d")
---
---     function k:entered() mjolnir.alert('Entered mode') end
---     function k:exited()  mjolnir.alert('Exited mode')  end
---
---     k:bind({}, 'escape', function() k:exit() end)
---     k:bind({}, 'J', function() mjolnir.alert("Pressed J") end)
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

    ]],
--]=]
}

-- private variables and methods -----------------------------------------

local fnutils = require("mjolnir.fnutils")
local hotkey = require("mjolnir.hotkey")

-- Public interface ------------------------------------------------------

-- set up metatable
module.__index = module

--- mjolnir._asm.modal_hotkey:entered()
--- Method
--- Optional callback for when a modal is entered; default implementation does nothing.
module.entered = function(self)
end

--- mjolnir._asm.modal_hotkey:exited()
--- Method
--- Optional callback for when a modal is exited; default implementation does nothing.
module.exited = function(self)
end

--- mjolnir._asm.modal_hotkey:bind(mods, key, pressedfn, releasedfn)
--- Method
--- Registers a new hotkey that will be bound when the modal is enabled.
module.bind = function(self, mods, key, pressedfn, releasedfn)
  local k = hotkey.new(mods, key, pressedfn, releasedfn)
  table.insert(self.keys, k)
  return self
end

--- mjolnir._asm.modal_hotkey:enter()
--- Method
--- Enables all hotkeys created via `modal:bind` and disables the modal itself. Called automatically when the modal's hotkey is pressed.
module.enter = function(self)
  self.k:disable()
  fnutils.each(self.keys, hotkey.enable)
  self.entered()
  return self
end

--- mjolnir._asm.modal_hotkey:exit()
--- Method
--- Disables all hotkeys created via `modal:bind` and re-enables the modal itself.
module.exit = function(self)
  fnutils.each(self.keys, hotkey.disable)
  self.k:enable()
  self.exited()
  return self
end

--- mjolnir._asm.modal_hotkey.new(mods, key) -> modal
--- Function
--- Creates a new modal hotkey and enables it. When mods and key are pressed, all keys bound via `modal:bind` will be enabled. They are disabled when the "mode" is exited via `modal:exit()`
module.new = function(mods, key)
  local m = setmetatable({keys = {}}, module)
  m.k = hotkey.bind(mods, key, function() m:enter() end)
  return m
end

--- mjolnir._asm.modal_hotkey.inject()
--- Function
--- Injects this module into `mjolnir.hotkey` as `mjolnir.hotkey.modal`.  This is to provide bindings similar to those used in Hydra, when modal was expected to be found attached to the `hydra.hotkey` name space.  Because of the caching used by Lua with `require`, invoking this function once will cause these functions to silently be available to any other module or lua input which has required `mjolnir.hotkey`.
---
--- To activate this behavior, put the following somewhere at the top of your `~/.mjolnir/init.lua` file:
--- <pre>
---     require("mjolnir._asm.modal_hotkey").inject()
--- </pre>
---
--- Calling this function is not a requirement to using this module; it is provided for backwards similarity/compatibility.
module.inject = function()
    hotkey.modal = module
end

-- Return Module Object --------------------------------------------------

return module

