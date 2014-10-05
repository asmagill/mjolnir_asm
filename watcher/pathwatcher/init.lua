--- === mjolnir._asm.pathwatcher ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.watcher
---
--- Watch paths recursively for changes.
---
--- This simple example watches your Hydra directory for changes, and when it sees a change, reloads your configs:
---
---     watcher.path.new(os.getenv("HOME") .. "/.hydra/", hydra.reload):start()
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

local module = require("mjolnir._asm.pathwatcher.internal")

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

--- mjolnir._asm.pathwatcher.new(path, fn) -> watcher
--- Constructor
--- Returns a new watcher.path that can be started and stopped.  The function registered receives as it's argument, a table containing a list of the files which have changed since it was last invoked.
function module.new(path, fn)
  local _fn = wrap(fn)

  local t = module._new(path, _fn)
  return t
end

-- Return Module Object --------------------------------------------------

return module



