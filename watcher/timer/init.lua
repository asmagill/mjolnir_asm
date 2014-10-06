--- === mjolnir._asm.timer ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.watcher
---
--- Execute functions with various timing rules.
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

local module = require("mjolnir._asm.timer.internal")

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

--- mjolnir._asm.timer.new(interval, fn) -> timer
--- Constructor
--- Creates a new timer that can be started; interval is specified in seconds as a decimal number.
function module.new(interval, fn)
  local _fn = wrap(fn)

  local t = module._new(interval, _fn)
  return t
end

--- mjolnir._asm.timer.doafter(sec, fn)
--- Function
--- Runs the function after sec seconds.
function module.doafter(sec, fn)
  local _fn = wrap(fn)

  local t = module._doafter(sec, _fn)
  return t
end

--- mjolnir._asm.timer.seconds(n) -> sec
--- Returns the number of seconds in seconds.
function module.seconds(n) return n end

--- mjolnir._asm.timer.minutes(n) -> sec
--- Returns the number of minutes in seconds.
function module.minutes(n) return 60 * n end

--- mjolnir._asm.timer.hours(n) -> sec
--- Returns the number of hours in seconds.
function module.hours(n)   return 60 * 60 * n end

--- mjolnir._asm.timer.days(n) -> sec
--- Returns the number of days in seconds.
function module.days(n)    return 60 * 60 * 24 * n end

--- mjolnir._asm.timer.weeks(n) -> sec
--- Returns the number of weeks in seconds.
function module.weeks(n)   return 60 * 60 * 24 * 7 * n end

-- Return Module Object --------------------------------------------------

return module



