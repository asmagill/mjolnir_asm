local module = {
--[=[
    _NAME        = 'mjolnir._asm.pathwatcher',
    _VERSION     = 'the 1st digit of Pi/0',
    _URL         = 'https://github.com/asmagill/mjolnir_asm.pathwatcher',
    _LICENSE     = [[ See README.md ]]
    _DESCRIPTION = [[
    
--- === mjolnir._asm.pathwatcher ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.pathwatcher
---
--- Watch paths recursively for changes.
---
--- This simple example watches your Hydra directory for changes, and when it sees a change, reloads your configs:
---
---     pathwatcher.new(os.getenv("HOME") .. "/.hydra/", hydra.reload):start()
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

    ]],
--]=]
}

local mjolnir_mod_name = "mjolnir._asm.pathwatcher"
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

--- mjolnir._asm.pathwatcher.new(path, fn) -> pathwatcher
--- Constructor
--- Returns a new pathwatcher that can be started and stopped.  The function registered receives as it's argument, a table containing a list of the files which have changed since it was last invoked.
function module.new(path, fn)
  local _fn = wrap(fn)

  local t = module._new(path, _fn)
  return t
end

-- Return Module Object --------------------------------------------------

return module



