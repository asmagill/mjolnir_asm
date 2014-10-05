local module = {
--[=[
    _NAME        = 'mjolnir._asm.applistener',
    _VERSION     = 'the 1st digit of Pi/0',
    _URL         = 'https://github.com/asmagill/mjolnir_asm.applistener',
    _LICENSE     = [[ See README.md ]]
    _DESCRIPTION = [[

--- === mjolnir._asm.applistener ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.applistener
---
--- Listen to notifications sent by other apps.
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

    ]],
--]=]
}

local mjolnir_mod_name = "mjolnir._asm.applistener"
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

