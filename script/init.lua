local module = {
--[=[
    _NAME        = 'mjolnir._asm.script',
    _VERSION     = 'the 1st digit of Pi/0',
    _URL         = 'https://github.com/asmagill/mjolnir_asm.script',
    _LICENSE     = [[ See README.md ]]
    _DESCRIPTION = [[
    
--- === mjolnir._asm.script ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.script
---
--- Functions for executing scripts outside of lua.
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

    ]],
--]=]
}

local mjolnir_mod_name = "mjolnir._asm.script"
local c_library = "internal"

-- integration with C functions ------------------------------------------

if c_library then
	for i,v in pairs(require(mjolnir_mod_name.."."..c_library)) do module[i] = v end
end

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

--- mjolnir._asm.script.applescript(string) -> bool, result
--- Function
--- Runs the given AppleScript string. If it succeeds, returns true, and the result as a string or number (if it can identify it as such) or  as a string describing the NSAppleEventDescriptor ; if it fails, returns false and an array containing the error dictionary describing why.
---
--- Use mjolnir._asm.script._applescript(string) if you always want the result as a string describing the NSAppleEventDescriptor.
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

--- mjolnir._asm.script.execute(command) -> rc, stdout
--- Function
--- A replacement for os.execute(command) which returns the result code and the stdout output from the shell command as a string. Similar to hydra.exec, but also returns a result code indicating success (0) or an error (any other number -- consult your command line shell man pages if you need to identify it more specifically).
module.execute = function(command)
    -- file handler will auto close via _gc when it goes out of scope, so...
    local str = io.popen(tostring(command)..";echo RC=$?",'r'):read('*a')
    local result, rc = str:match("^(.*)RC=(%d+)%s*$")
    if type(rc) == "nil" then
        return -99, "Unable to enter shell" -- reading online, supposedly this is occasionally possible in extremely rare occasions, though that was lua 5.1... hopefully it will never happen in 5.2, but this is here just in case.
    else
        return tonumber(rc), result
    end
end

-- Return Module Object --------------------------------------------------

return module



