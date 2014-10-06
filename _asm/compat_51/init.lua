--- === mjolnir._asm.compat_51 ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.compat_51
---
--- The Lua 5.2 engine included with [Mjolnir](http://mjolnir.io) does not include the Lua 5.1 deprecated functions in it's build.  I actually agree with this because new code should be written to a current standard and updates should be encouraged.
--- 
--- However, this is not always possible, and many modules exist which *almost* work under Lua 5.2, but just need a few supporting functions to continue to be viable.
--- 
--- Here I have attempted to replicate the compatibility functions within the Lua 5.2.3 source code as a separate module so that they can be added as needed, and removed when not. This code is almost entirely from the Lua 5.2.3 source (http://www.lua.org/download.html) and is just packaged for convenience.
--- 
--- The following Lua 5.1 functions and variables are "created" when the `enable` function is invoked:
--- 
--- * loadstring(*string* [, *chunk*])
--- * math.log10(*number*)
--- * module(*name* [, ...])
--- * package.seeall(*module*)
--- * package.loaders
--- * table.maxn(*table*)
--- * unpack(*list* [, *i* [, *j*]])
--- 
--- See (http://www.lua.org/manual/5.2/manual.html#8) for more details.

local module = {}
local lua51 = require("mjolnir._asm.compat_51.internal")

-- private variables and methods -----------------------------------------

lua51["unpack"] = table.unpack
lua51["package_loaders"] = package.searchers
lua51["loadstring"] = load

local backup = {}

local setfunction = function(key_path, value)
    local root = _G
    local pathPart, keyPart

    for part, sep in string.gmatch(key_path, "([%w]+)(_?)") do
        if sep ~= "" then
            if type(root[part]) == "table" then
                root[part] = root[part] or {}
                root = root[part]
            else
                mjolnir.showerror("Unable to traverse "..key_path.." for some reason.")
                return nil
            end
        else
            backup[key_path] = root[part]
            root[part] = value
            return root[part]
        end
    end
end

-- Public interface ------------------------------------------------------

--- mjolnir._asm.compat_51.status
--- Variable
--- Boolean variable indicating whether or not Lua 5.1 compatibility functions are enabled or not.
module.status = false

--- mjolnir._asm.compat_51.enable()
--- Function
--- Enable Lua 5.1 Compatibility features by adding the appropriate functions into the expected globals.
module.enable = function()
    if module.status == true then return end
    for key, value in pairs(lua51) do
        setfunction(key, value)
    end
    rawset(module,"status",true)
end

--- mjolnir._asm.compat_51.disable()
--- Function
--- Disable Lua 5.1 Compatibility features by removing them from the global namespace.
module.disable = function()
    if module.status == false then return end
    for key, value in pairs(lua51) do
        setfunction(key, backup[key])
    end
    rawset(module,"status",false)
end

--- mjolnir._asm.compat_51.pcall(f, ...) -> bool [,...]
--- Function
--- Similar to pcall, but with Lua 5.1 compatibility functions enabled for the call only.
module.pcall = function(f, ...)
    local incoming_status = module.status
    
    if not incoming_status then module.enable() end
    local results = table.pack(pcall(function(...) return f(...) end))
    if not incoming_status then module.disable() end
    
    return table.unpack(results)
end

-- Return Module Object --------------------------------------------------

return module



