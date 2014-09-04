local module = {
--[=[
    _NAME        = 'mjolnir._asm.modules',
    _VERSION     = 'the 1st digit of Pi/0',
    _URL         = 'https://github.com/asmagill/mjolnir._asm.toolkit',
    _LICENSE     = [[ See README.md ]]
    _DESCRIPTION = [[
    
--- === mjolnir._asm.modules ===
---
--- Not entirely sure yet where or how far I'll go with this, but this is my first
--- attempts at adding code to provide some mechanism for being aware of updates to
--- luarocks which are used in your Mjolnir setup.

    ]],
--]=]
}

local mjolnir_mod_name = "_asm.modules"
--local c_library = "internal"

-- integration with C functions ------------------------------------------

if c_library then
	for i,v in pairs(require("mjolnir."..mjolnir_mod_name.."."..c_library)) do module[i] = v end
end

-- private variables and methods -----------------------------------------

local lua51 = require("mjolnir._asm.compat_51")

lua51.enable()
local lr_cfg = require("luarocks.cfg")
local lr_search = require("luarocks.search")
local lr_path = require("luarocks.path")
lua51.disable()

local tree_array = function(name)
    local answer = {}
    
    if name then
        for _, v in pairs(lr_cfg.rocks_trees) do
            if name == v.name then
                answer = { v }
                break
            end
        end
    else
        answer = lr_cfg.rocks_trees
    end
    
    return answer
end

local compare_versions = function(a,b)
    local aver, ars = a:match("(.*)-(.*)")
    local bver, brs = b:match("(.*)-(.*)")
    local averp, arsp = {}, {}
    local bverp, brsp = {}, {}
    
    for p in aver:gmatch("(%d+)") do table.insert(averp, tonumber(p)) end
    for p in bver:gmatch("(%d+)") do table.insert(bverp, tonumber(p)) end
    for p in ars:gmatch("(%d+)") do table.insert(arsp, tonumber(p)) end
    for p in brs:gmatch("(%d+)") do table.insert(brsp, tonumber(p)) end

    for i = 1, #averp, 1 do
        if i > #bverp then return false end
        if averp[i] ~= bverp[i] then return averp[i] < bverp[i] end
    end
    
    for i = 1, #arsp, 1 do
        if i > #brsp then return false end
        if arsp[i] ~= brsp[i] then return arsp[i] < brsp[i] end
    end
        
    return false
end

local latest_version = function(data)
    local t = {}
    for i,v in pairs(data) do table.insert(t,i) end
    
    table.sort(t, compare_versions)
    
    return t[#t]

end


-- Public interface ------------------------------------------------------

--- mjolnir._asm.modules.trees() -> table
--- Function
---
module.trees = function()
    local t = {}
    for _, v in ipairs(lr_cfg.rocks_trees) do
        table.insert(t, v.name)
    end
    return t
end

module.installed = function(tree)
    local trees = tree_array(tree)
    local results = {}
    local query
    
    for _, v in ipairs(trees) do
        query = lr_search.make_query("")
        query.exact_name = false
        lr_search.manifest_search(results, lr_path.rocks_dir(v), query)
    end
    
    return results
end

module.available = function(name, exact)
    name = name or ""
    local results = {}
    local query = lr_search.make_query(name:lower())
    query.exact_name = exact or false
    results = lr_search.search_repos(query)
    
    return results
end

module.versions = function(tree)
    local results = {}
    local available
    
    for name, data in pairs(module.installed(tree)) do
        remote = module.available(name, true)
        results[name] = { installed = latest_version(data) }
        if not remote[name] then
            results[name].available = results[name].installed
            results[name].local_only = true
        else
            results[name].available = latest_version(remote[name])
            results[name].local_only = false
        end        
        results[name].upgrade = compare_versions(results[name].installed, results[name].available)
    end
    return results
end

-- Return Module Object --------------------------------------------------

return module

--    query = luarocks.search.make_query("")
--    query.exact_name = false
--    luarocks.search.search_repos(query)


