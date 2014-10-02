local module = {
--[=[
    _NAME        = 'mjolnir._asm.http',
    _VERSION     = 'the 1st digit of Pi/0',
    _URL         = 'https://github.com/asmagill/mjolnir_asm.http',
    _LICENSE     = [[ See README.md ]]
    _DESCRIPTION = [[

--- === mjolnir._asm.http ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.http
---
--- For making HTTP/HTTPS requests
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

    ]],
--]=]
}

local mjolnir_mod_name = "mjolnir._asm.http2"
local c_library = "internal"
local internal = {}

-- integration with C functions ------------------------------------------

--if c_library then
--	for i,v in pairs(require(mjolnir_mod_name.."."..c_library)) do module[i] = v end
--end

module = require(mjolnir_mod_name.."."..c_library)

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

--- mjolnir._asm.http.new(url, method, timeout, headers, body, fn(code, header, data, err)) -> task
--- Function
--- Create an HTTP request using the given method, with the following parameters:
---   url must be a string
---   method must be a string (i.e. "GET")
---   timeout must be a number
---   headers must be a table; may be empty; any keys and values present must both be strings
---   body may be a string or nil
---   fn must be a valid function, and is called with the following parameters:
---     code is a number (is sometimes 0, I think?)
---     header is a table of string->string pairs
---     data is a string on success, nil on failure
---     err is a string on failure, nil on success
module.new = function(url, method, timeout, headers, body, fn)
  local _fn = wrap(fn)

  local t = module._new(url, method, timeout, headers, body, _fn)
  return t
end

--- mjolnir._asm.http.send(url, method, timeout, headers, body, fn(code, header, data, err)) -> task
--- Function
--- Shorthand for mjolnir._asm.http.send(...):start()
module.send = function(...)
  return module.new(...):start()
end


-- Return Module Object --------------------------------------------------

return module
