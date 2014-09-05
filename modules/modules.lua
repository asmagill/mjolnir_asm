local modules = {
--[=[
    _NAME        = 'mjolnir._asm.modules',
    _VERSION     = 'the 1st digit of Pi/0',
    _URL         = 'https://github.com/asmagill/mjolnir._asm.toolkit',
    _LICENSE     = [[ See README.md ]]
    _DESCRIPTION = [[

--- === mjolnir._asm.modules ===
---
--- Functions to capture information from luarocks about installed mjolnir modules.
--- While it is tailored specifically to use with the mjolnir modules, it should
--- work with luarocks in general.
---
--- This is very basic, and does not support specifying a specific version for removal,
--- if multiple versions are installed, or installing a specific version.  This may
--- change in the future.
---
--- Note that this ends up loading practically all of the luarocks modules into memory
--- and may leave Mjolnir in an inconsistent state concerning available modules.  You
--- should probably only require this module when you specifically want it, and then
--- run mjolnir.reload() when done.

    ]],
--]=]
}

local mjolnir_mod_name = "_asm.modules"

-- private variables and methods -----------------------------------------

local lua51
if _G.module and _G.package.seeall then
    lua51 = { enable = function() end, disable = function() end, pcall = _G.pcall }
else
    lua51 = require("mjolnir._asm.compat_51")
end

local mjolnir = mjolnir or { showerror = error }

lua51.enable()
local cfg = require("luarocks.cfg")
local search = require("luarocks.search")
local path = require("luarocks.path")
lua51.disable()

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

--- mjolnir._asm.modules.trees([name]) -> table
--- Function
--- Returns a table of the luarocks tree definition name, or all of the tree definitions
--- if name is not provided.
modules.trees = function(name)
    local answer = {}

    if name then
        for _, v in pairs(cfg.rocks_trees) do
            if name == v.name then
                answer = { v }
                break
            end
        end
    else
        answer = cfg.rocks_trees
    end

    return answer
end

--- mjolnir._asm.modules.installed([tree]) -> table
--- Function
--- Returns a table containing the luarocks manifest of installed modules for a tree.
--- If tree is absent, it defaults to the "mjolnir" tree.  If tree is --all, then it
--- returns the manifest for all installed modules.  Otherwise it returns the manifest
--- for the specified tree.
modules.installed = function(tree)
    tree = tree or "mjolnir"

    local trees = tree == "--all" and modules.trees() or modules.trees(tree)
    local results = {}
    local query

    for _, v in ipairs(trees) do
        query = search.make_query("")
        query.exact_name = false
        search.manifest_search(results, path.rocks_dir(v), query)
    end

    return results
end
--- mjolnir._asm.modules.available([name] [, exact]) -> table
--- Function
--- Returns a table containg the manifest of available (remote) modules which contain
--- name in their name.  If exact is true, then the module name must match name exactly.
--- If name and exact are both missing, then it returns all available modules, similar
--- to "luarocks search --all".
modules.available = function(name, exact)
    name = name or ""
    local results = {}
    local query = search.make_query(name:lower())
    query.exact_name = exact or false
    results = search.search_repos(query)

    return results
end

--- mjolnir._asm.modules.versions([tree]) -> table
--- Function
--- Returns a table containing the list of modules in the specified tree (if tree is absent,
--- then default to tree "mjolnir"; if tree is --all, then all available trees) with the
--- following atributes:
---     installed = the version string for the installed version
---     available = the latest version string available for download
---     local_only = a boolean indicating that the module does not appear in any known repository
---     upgrade = a boolean indicating if the available version is greater than the installed one
modules.versions = function(tree)
    local results = {}
    local available

    for name, data in pairs(modules.installed(tree)) do
        remote = modules.available(name, true)
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

--- mjolnir._asm.modules.remove(name, [tree]) -> boolean [, error]
--- Function
--- Tries to remove the specified module from the specified tree (defaults to mjolnir).
--- Returns true or false indicating success or failure.
modules.remove = function(name, tree)
    local _, remove = lua51.pcall(function() return require("luarocks.remove") end)
    tree = tree or "mjolnir"
    local results = {}
    local trees = m.trees(tree)
    
    if #trees ~= 1 then
        return nil, "Tree '"..tostring(tree).."' does not exist."
    end
    
    path.use_tree(trees[1])

    results = table.pack(lua51.pcall(function() return remove.run("--tree="..tree, name) end))
    if results[1] then
        if type(results[2]) == "nil" then results[2] = false end
        table.remove(results, 1)
        return table.unpack(results)
    else
        mjolnir.showerror(results[2])
    end
end

--- mjolnir._asm.modules.install(name, [tree]) -> name, version | false, error
--- Function
--- Tries to install the specified module into the specified tree (defaults to mjolnir).
--- Returns the name and version of the module installed, if successful.
modules.install = function(name, tree)
    local _, install = lua51.pcall(function() return require("luarocks.install") end)
    tree = tree or "mjolnir"
    local results = {}
    local trees = m.trees(tree)
    
    if #trees ~= 1 then
        return nil, "Tree '"..tostring(tree).."' does not exist."
    end
    
    path.use_tree(trees[1])

    results = table.pack(lua51.pcall(function() return install.run("--tree="..tree, name) end))
    if results[1] then
        if type(results[2]) == "nil" then results[2] = false end
        table.remove(results, 1)
        return table.unpack(results)
    else
        mjolnir.showerror(results[2])
    end
end

-- Return Module Object --------------------------------------------------

return modules
