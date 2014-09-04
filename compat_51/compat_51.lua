local module = {
--[=[
    _NAME        = 'mjolnir._asm.compat_51',
    _VERSION     = 'the 1st digit of Pi/0',
    _URL         = 'https://github.com/asmagill/mjolnir._asm.compat_51',
    _LICENSE     = [[ See README.md ]]
    _DESCRIPTION = [[
    
--- === mjolnir._asm.compat_51 ===
---
--- Provides Lua 5.1 compatibility features left out of the Lua 5.2 library included with Mjolnir.
--- Because new code should be written to the 5.2 or 5.3 specifications, you should only enable these
--- functions as required, and disable them when testing new code.

    ]],
--]=]
}

local mjolnir_mod_name = "_asm.compat_51"
local c_library = "internal"

-- integration with C functions ------------------------------------------

local lua51 = require("mjolnir."..mjolnir_mod_name.."."..c_library)

-- private variables and methods -----------------------------------------

lua51["unpack"] = table.unpack
lua51["package_loaders"] = package.searchers
lua51["loadstring"] = load

local setfunction = function(key_path, value)
    local root = _G
    local pathPart, keyPart

    for part, sep in string.gmatch(key_path, "([%w]+)(_?)") do
        if sep ~= "" then
            if type(root[part]) == "table" then
                root[part] = root[part] or {}
                root = root[part]
            else
                error("Unable to traverse "..key_path.." for some reason.", 2)
                return nil
            end
        else
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
    for key, value in pairs(lua51) do
        setfunction(key, value)
    end
    rawset(module,"status",true)
end

--- mjolnir._asm.compat_51.disable()
--- Function
--- Disable Lua 5.1 Compatibility features by removing them from the global namespace.
module.disable = function()
    for key, value in pairs(lua51) do
        setfunction(key, nil)
    end
    rawset(module,"status",false)
end

-- Return Module Object --------------------------------------------------

return module



