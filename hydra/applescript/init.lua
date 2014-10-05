--- === mjolnir._asm.hydra.applescript ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.hydra
---
--- Functions for executing AppleScript from within Mjolnir.
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

local module = require("mjolnir._asm.hydra.applescript.internal")

-- private variables and methods -----------------------------------------

local split = function(div,str)
    if (div=='') then return { str } end
    local pos,arr = 0,{}
    for st,sp in function() return string.find(str,div,pos) end do
        table.insert(arr,string.sub(str,pos,st-1))
        pos = sp + 1
    end
    if string.sub(str,pos) ~= "" then
        table.insert(arr,string.sub(str,pos))
    end
    return arr
end

-- Public interface ------------------------------------------------------

--- mjolnir._asm.hydra.applescript.applescript(string) -> bool, result
--- Function
--- May also be invoked as mjolnir._asm.applescript(string).
---
--- Runs the given AppleScript string. If it succeeds, returns true, and the result as a string or number (if it can identify it as such) or  as a string describing the NSAppleEventDescriptor ; if it fails, returns false and an array containing the error dictionary describing why.
---
--- Use mjolnir._asm.hydra.applescript._applescript(string) if you always want the result as a string describing the NSAppleEventDescriptor.
module.applescript = function(command)
    local ok, result = module._applescript(command)
    local answer

    if not ok then
        result = result:match("^{\n(.*)}$")
        answer = {}
        local lines = split(";\n", result)
        for _, line in ipairs(lines) do
            local k, v = line:match('^%s*(%w+)%s=%s(.*)$')
            v = v:match('^"(.*)"$') or v:match("^'(.*)'$") or v
            answer[k] = tonumber(v) or v
        end
    else
        result = result:match("^<NSAppleEventDescriptor: (.*)>$")
        if tonumber(result) then
            answer = tonumber(result)
        elseif result:match("^'utxt'%(.*%)$") then
            result = result:match("^'utxt'%((.*)%)$")
            answer = result:match('^"(.*)"$') or result:match("^'(.*)'$") or result
        else
            answer = result
        end
    end
    return ok, answer
end

setmetatable(module, { __call = function(_, ...) return module.applescript(...) end })

-- Return Module Object --------------------------------------------------

return module

-- collection of return types I need to catch, and then maybe time to recursively parse through 'obj' results
--
-- > _h.hydra.runapplescript("")
-- true	null()
-- > _h.hydra.runapplescript("return true")
-- true	'true'("true")
-- > _h.hydra.runapplescript("return false")
-- true	'fals'("false")
-- > _h.hydra.runapplescript("return null")
-- true	'null'


