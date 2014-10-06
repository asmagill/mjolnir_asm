--- === mjolnir._asm.modules ===
---
--- Home: https://github.com/asmagill/mjolnir_asm._asm
---
--- Functions to capture information about, install and remove luarocks for mjolnir modules.
--- While it is tailored specifically to use with the mjolnir modules, it should
--- work with luarocks in general.
---
--- This is very basic, and experimental. Note that any luarocks compatible arguments
--- specified after the tree for remove and install are passed in as is, so format
--- accordingly, and very few cases have been tested so far, so it's still very beta!
---
--- These tools assume a default Luarocks tree named "mjolnir" exists.  You can always
--- specify a different tree name if you wish.  To use the "mjolnir" tree, make sure
--- something like the following is in your `~/.luarocks/config.lua` file:
--- ~~~lua
---        rocks_trees = {
---                { name = [[user]], root = home..[[/.luarocks]] },
---                { name = [[mjolnir]], root = home..[[/.mjolnir/rocks]] },
---                { name = [[system]], root = [[/usr/local]] },
---        }
--- ~~~
--- Note that this ends up loading practically all of the luarocks modules into memory
--- and may leave Mjolnir in an inconsistent state concerning available modules.  You
--- should probably only require this module when you specifically want it, and then
--- run mjolnir.reload() when done.
---
--- `mjolnir-tools` is a command-line tool which is installed into your tree bin
--- directory (~/.mjolnir/rocks/bin, if you use the mjolnir tree as shown above). To use
--- this utility, make sure that the directory is in your shell's PATH or copy/link the
--- file to somewhere that is.
---
--- To change the default tree from "mjolnir" to something else, you can use the module's
--- `default_tree` variable (see Variables), or to make it permanent, create a file in your
--- `.mjolnir` directory named `.mjolnir._asm.modules.lua` and put the following into it
--- (change "mjolnir" to match your preferred default tree):
--- ~~~lua
---     return {
---         -- default_tree: is the luarocks tree to use by default
---         default_tree = "mjolnir",
---     }
--- ~~~

--- mjolnir._asm.modules.default_tree = string
--- Variable
--- By default, this module assumes the default luarocks tree is "mjolnir".  You
--- can set this variable to another value if you wish the default tree to be
--- something else.
--- If you want to permanently change the default tree to something else, create
--- a file in your .mjolnir/ directory named ".mjolnir._asm.modules.lua" and put
--- the following into it (change "mjolnir" to match your preferred default tree):
--- ~~~lua
---        return {
---             -- default_tree: is the luarocks tree to use by default
---             default_tree = "mjolnir",
---        }
--- ~~~

local modules = {}

local ok, value = pcall(function()
    return dofile(os.getenv("HOME").."/.mjolnir/.mjolnir._asm.modules.lua")
end)
if type(value) ~= "table" then ok = false end
modules.default_tree = ok and value.default_tree or "mjolnir"

-- private variables and methods -----------------------------------------

local lua51
if _G.module and _G.package.seeall then
    lua51 = { enable = function() end, disable = function() end, pcall = _G.pcall }
else
    lua51 = require("mjolnir._asm.compat_51")
end

local mjolnir = mjolnir or { showerror = error }

local backup_io = {
    stderr = io.stderr,
    stdout = io.stdout,
}

local captured_output = ""

local compare_versions = function(a,b)
--
-- luarocks version format: x(%.y)*-z
--      x and y are probably numbers... but maybe not... z is a number
--
-- More generically, we actually accept _ or . as a separator, but only -
-- separates the two parts to be considered independently; and for z,
-- we actually treat it the same way as x(%.y)*, even though I think this
-- violates the luarocks spec.
--
-- Our rules for testing:
-- 1. if a or b start with "v" or "r" followed immediately by a number, drop
--    the letter.
-- 2. break apart into x(%.y)* and z (we actually allow the same rules on z
--    as we do for the first part, but if I understand the rockspec correctly,
--    this should never actually happen)
-- 3. first compare the x(%.y)* part.  If they are the same, only then compare
--    the z part.
--
-- repeat the following for each part:
-- 1. if the version matches so far, and a has more components, then return
--    a > b. e.g. 3.0.1 > 3.0 (of course 3.0.0 > 3.0 as well... should that
--    change?)
-- 2. if either part n of a or part n of b cannot be successfully changed to
--    a number, compare as strings, otherwise compare as numbers.
--
-- This does mean that the following probably won't work correctly, but at
-- least with luarocks, none have been this bad yet...
--
--  3.0rc2 and 3.0.rc1 (inconsistent lengths of parts)
--  3.0.0 and 3.0 being "equal" (should they be?)
--  "dev" being newer than "alpha" or "beta"
--  "final" being newer than "rc" or "release"
--  dates as version numbers that aren't yyyymmdd
--  runs of 0's (tonumber("00") == tonumber("000"))
--  "1a" and "10a"
--
-- others?

    a = a or ""
    b = b or ""

    a = a:match("^[vr]?(%d.*)$") or a
    b = b:match("^[vr]?(%d.*)$") or b

--    print(a,b)

    local aver, ars = a:match("([%w%._]*)-?([%w%._]*)")
    local bver, brs = b:match("([%w%._]*)-?([%w%._]*)")
    local averp, arsp = {}, {}
    local bverp, brsp = {}, {}

    aver, ars, bver, brs = aver or "", ars or "", bver or "", brs or ""

    for p in aver:gmatch("([^%._]+)") do table.insert(averp, p) end
    for p in bver:gmatch("([^%._]+)") do table.insert(bverp, p) end
    for p in ars:gmatch("([^%._]+)") do table.insert(arsp, p) end
    for p in brs:gmatch("([^%._]+)") do table.insert(brsp, p) end

    for i = 1, #averp, 1 do
        if i > #bverp then return false end
--        print(averp[i],bverp[i])
        if tonumber(averp[i]) and tonumber(bverp[i]) then
            averp[i] = tonumber(averp[i])
            bverp[i] = tonumber(bverp[i])
        end
        if averp[i] ~= bverp[i] then return averp[i] < bverp[i] end
    end

    for i = 1, #arsp, 1 do
        if i > #brsp then return false end
--        print(arsp[i],brsp[i])
        if tonumber(arsp[i]) and tonumber(brsp[i]) then
            arsp[i] = tonumber(arsp[i])
            brsp[i] = tonumber(brsp[i])
        end
        if arsp[i] ~= brsp[i] then return arsp[i] < brsp[i] end
    end

    return false
end

local sorted_versions = function(data, desc)
    local t = {}
    desc = desc or false
    for i,v in pairs(data) do table.insert(t,i) end

    table.sort(t, function(a,b)
        if desc then
            return compare_versions(b, a)
        else
            return compare_versions(a, b)
        end
    end)

    return t
end

local latest_version = function(data)
    local t = sorted_versions(data)

    return t[#t]

end

local function add_io(self, real_io, ...)
    captured_output = captured_output..table.concat({...})

    return real_io:write(...)
end

local function capture_io()
    backup_io = {
        stderr = io.stderr,
        stdout = io.stdout,
    }

    io.stderr = {
        write = function(self, ...) return add_io(self, backup_io.stderr, ...) end,
        close = function(self, ...) return backup_io.stderr:close(...) end,
        flush = function(self, ...) return backup_io.stderr:flush(...) end,
        lines = function(self, ...) return backup_io.stderr:lines(...) end,
        read = function(self, ...) return backup_io.stderr:read(...) end,
        seek = function(self, ...) return backup_io.stderr:seek(...) end,
        setvbuf = function(self, ...) return backup_io.stderr:setvbuf(...) end,
    }
    io.stdout = {
        write = function(self, ...) return add_io(self, backup_io.stdout, ...) end,
        close = function(self, ...) return backup_io.stdout:close(...) end,
        flush = function(self, ...) return backup_io.stdout:flush(...) end,
        lines = function(self, ...) return backup_io.stdout:lines(...) end,
        read = function(self, ...) return backup_io.stdout:read(...) end,
        seek = function(self, ...) return backup_io.stdout:seek(...) end,
        setvbuf = function(self, ...) return backup_io.stdout:setvbuf(...) end,
    }
end

local function release_io()
    io.stderr = backup_io.stderr
    io.stdout = backup_io.stdout
end

local mt_array = { __call = function(self, ...)
        local number = table.pack(...)[1] or 0
        return self[#self - number]
    end
}

-- Public interface ------------------------------------------------------

--- mjolnir._asm.modules.output[]
--- Variable
--- Because Luarocks outputs most of it's status and errors via io.stdout:write(),
--- we capture the stderr and stdout streams during module install and removal. To
--- see the full output of the last install or remove invocation, just look at the
--- end of this array, i.e.
---     print(mjolnir._asm.modules.output[#mjolnir._asm.modules.output])

--- mjolnir._asm.modules.output( n ) -> string
--- Function
--- Because Luarocks outputs most of it's status and errors via io.stdout:write(),
--- we capture the stderr and stdout streams during module install and removal. This
--- function returns the output of the most recent - n install or remove.  When n is
--- not provided, it is 0, resulting in the most recent install or remove.
modules.output = {}
setmetatable(modules.output, mt_array)

--- mjolnir._asm.modules.trees([name]) -> table
--- Function
--- Returns a table of the luarocks tree definition name, or all of the tree definitions
--- if name is not provided.
modules.trees = function(name)
    local _, cfg = lua51.pcall(function() return require("luarocks.cfg") end)

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
    local _, search = lua51.pcall(function() return require("luarocks.search") end)
    local _, path = lua51.pcall(function() return require("luarocks.path") end)
    tree = tree or modules.default_tree

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
    local _, search = lua51.pcall(function() return require("luarocks.search") end)
    name = name or ""
    local results = {}
    local query = search.make_query(name:lower())
    query.exact_name = exact or false
    results = search.search_repos(query)

    return results
end

--- mjolnir._asm.modules.sorted_versions(manifestdata [, desc]) -> table
--- Function
--- Returns a sorted array of the versions available in the manifest data provided.
--- This manifest data is a specific module's result value from a search.  If desc
--- is true return the list in descending order; otherwise in ascending order.
modules.sorted_versions = sorted_versions

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
            results[name].available = ""
            results[name].local_only = true
        else
            results[name].available = latest_version(remote[name])
            results[name].local_only = false
        end
        results[name].upgrade = compare_versions(results[name].installed, results[name].available)
    end
    return results
end

--- mjolnir._asm.modules.remove(name [, tree [, ... ]]) -> boolean [, error]
--- Function
--- Tries to remove the specified module from the specified tree (defaults to mjolnir).
--- If other arguments are provided after tree, they are passed into luarocks as is,
--- so format accordingly. Returns true or false indicating success or failure.
modules.remove = function(name, tree, ...)
    local _, remove = lua51.pcall(function() return require("luarocks.remove") end)
    local _, path = lua51.pcall(function() return require("luarocks.path") end)
    tree = tree or modules.default_tree
    local results = {}
    local trees = modules.trees(tree)
    local extraArgs = table.pack(...)

    if #trees ~= 1 then
        return nil, "Tree '"..tostring(tree).."' does not exist."
    end

    path.use_tree(trees[1])

    capture_io()
    results = table.pack(lua51.pcall(function() return remove.run("--tree="..tree, name, table.unpack(extraArgs)) end))
    release_io()
    table.insert(modules.output, captured_output)
    captured_output = ""

    if results[1] then
        if type(results[2]) == "nil" then results[2] = false end
        table.remove(results, 1)
        return table.unpack(results)
    else
        mjolnir.showerror(results[2])
    end
end

--- mjolnir._asm.modules.install(name [, tree [, ... ]]) -> name, version | false, error
--- Function
--- Tries to install the specified module into the specified tree (defaults to mjolnir).
--- If other arguments are provided after tree, they are passed into luarocks as is, so
--- format accordingly. Returns the name and version of the module installed, if successful.
modules.install = function(name, tree, ...)
    local _, install = lua51.pcall(function() return require("luarocks.install") end)
    local _, path = lua51.pcall(function() return require("luarocks.path") end)
    tree = tree or modules.default_tree
    local results = {}
    local trees = modules.trees(tree)
    local extraArgs = table.pack(...)

    if #trees ~= 1 then
        return nil, "Tree '"..tostring(tree).."' does not exist."
    end

    path.use_tree(trees[1])

    capture_io()
    results = table.pack(lua51.pcall(function() return install.run("--tree="..tree, name, table.unpack(extraArgs)) end))
    release_io()
    table.insert(modules.output, captured_output)
    captured_output = ""

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
