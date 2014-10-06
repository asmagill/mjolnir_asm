--- === mjolnir._asm.data.base64 ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.data
---
--- This module provides base64 encoding and decoding for Mjolnir.
---
--- Portions sourced from (https://gist.github.com/shpakovski/1902994).

local module = require("mjolnir._asm.data.base64.internal")

-- private variables and methods -----------------------------------------

-- Public interface ------------------------------------------------------

--- mjolnir._asm.data.base64.encode(val[,width]) -> str
--- Function
--- Returns the base64 encoding of the string provided, optionally split into lines of `width` characters per line.
module.encode = function(data, width)
    local _data = module._encode(data)
    if width then
        local _hold, i, j = _data, 1, width
        _data = ""
        repeat
            _data = _data.._hold:sub(i,j).."\n"
            i = i + width
            j = j + width
        until i > #_hold
    end
    return _data:sub(1,#_data - 1)
end

--- mjolnir._asm.data.base64.decode(str) -> val
--- Function
--- Returns a Lua string representing the given base64 string.
module.decode = function(data)
    return module._decode(data:gsub("[\r\n]+",""))
end

-- Return Module Object --------------------------------------------------

return module
