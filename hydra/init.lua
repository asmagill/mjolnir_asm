local module = {
--[=[
    _NAME        = 'mjolnir._asm.hydra',
    _VERSION     = 'the 1st digit of Pi/0',
    _URL         = 'https://github.com/asmagill/mjolnir_asm.hydra',
    _LICENSE     = [[ See README.md ]]
    _DESCRIPTION = [[

--- === mjolnir._asm.hydra ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.hydra
---
--- Minor functions from Hydra and a checklist function for indicating Hydra function replacements.
---
--- This module provides some of the functionality which Hydra had regarding its environment, but aren't currently in a module of their own for various reasons.
---
--- This module is not needed for any of the submodules, and the submodules can be loaded and installed independently of this one. Loads all of the modules corresponding to Hydra's internal functions.  This module is not strictly needed, as it will load as many of the modules as have been created so far.  Individual modules can be loaded if you prefer only specific support.
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

    ]],
--]=]
}

local mjolnir_mod_name = "mjolnir._asm.hydra"
local c_library = "internal"

-- integration with C functions ------------------------------------------

if c_library then
	for i,v in pairs(require(mjolnir_mod_name.."."..c_library)) do module[i] = v end
end

-- private variables and methods -----------------------------------------

local my_require = function(label, name)
	if type(name) == "nil" then
		print(label.."\t no module is known to exist for this yet.")
		return nil
	else
    	local ok, value = xpcall(require, function(...) return ... end, name)
    	if ok then
        	return value
    	else
        	print(label.."\t is provided by "..name)
        	return nil
    	end
    end
end

-- Public interface ------------------------------------------------------

--- mjolnir._asm.hydra.call(fn, ...) -> ...
--- Function
--- Just like pcall, except that failures are handled using `mjolnir.showerror`
module.call = function(fn, ...)
    local results = table.pack(pcall(fn, ...))
    if not results[1] then
        -- print(debug.traceback())
        mjolnir.showerror(results[2])
    end
    return table.unpack(results)
end

--- mjolnir._asm.hydra.exec(command[, with_user_env]) -> string
--- Function
--- Runs a shell command and returns stdout as a string (may include a trailing newline).  If `with_user_env` is `true`, then invoke the user's default shell as an interactive login shell in which to execute the provided command in order to make sure their setup files are properly evaluated so extra path and environment variables can be set.  This is not done, if `with_user_env` is `false` or not provided, as it does add some overhead and is not always strictly necessary.
module.exec = function(command, user_env)
    local f
    if user_env then
        f = io.popen(os.getenv("SHELL").." -l -i -c \""..command.."\"", 'r')
    else
        f = io.popen(command, 'r')
    end
    local s = f:read('*a')
    f:close()
    return s
end

--- mjolnir._asm.hydra.hydra_namespace() -> table
--- Function
--- Returns the full hydra name space replicated as closely as reasonable for Mjolnir.  Really more of a checklist then a real environment to choose to live in &lt;grin&gt;.
---
--- This module attempts to require modules known to provide former Hydra functionality and prints a list to the Mjolnir console indicating what modules you don't have and which Hydra modules are currently have no known replacement in Mjolnir.  If you think that an existing module does exist to cover lost functionality, but it is not represented here, please let me know and I'll add it.
---
--- This module returns a table of the Hydra namespace, as it has been able to be reconstituted with your installed modules.
---
--- **NOTE:**  While this function does load the compatible modules into memory, it does so *only when you invoke this function*.  Until and unless you call this function, no additional modules are loaded into memory.
module.hydra_namespace = function()
    local _H = {
        _registry               = { "mjolnir userdata uses the stack registry, not this one." },
        application             = my_require("application", "mjolnir.application"),
        audiodevice             = my_require("audiodevice", "mjolnir._asm.sys.audiodevice"),
        battery                 = my_require("battery", "mjolnir._asm.sys.battery"),
        brightness              = my_require("brightness", "mjolnir._asm.sys.brightness"),
        doc                     = my_require("doc", nil),
        eventtap                = my_require("eventtap", "mjolnir._asm.eventtap"),
        ext                     = {},
        fnutils                 = my_require("fnutils", "mjolnir.fnutils"),
        geometry                = my_require("geometry", "mjolnir.geometry"),
        help                    = my_require("help", nil),
        hotkey                  = my_require("hotkey", "mjolnir.hotkey"),
        http                    = my_require("http", nil),
        hydra = {
            _initiate_documentation_system = nil,
            alert               = my_require("hydra.alert", "mjolnir.alert"),
            autolaunch          = { get = module.autolaunch, set = module.autolaunch },
            call                = module.call,
            check_accessibility = module.check_accessibilitiy,
            dockicon            = my_require("hydra.docicon", "mjolnir._asm.hydra.dockicon"),
            docsfile            = nil,
            errorhandler        = mjolnir.showerror,
            exec                = module.exec,
            exit                = mjolnir._exit,
            fileexists          = module.fileexists,
            focushydra          = mjolnir.focus,
            ipc                 = my_require("hydra.ipc", "mjolnir._asm.ipc"),
            license             = {
                    -- Table of functions used for license entry and verification of Hydra...
                    -- never really used, but here solely for the sake of completeness (some
                    -- would say analness; but consider that I thought, for about 2 seconds,
                    -- about actually reproducing the code, rather than just the results).
                                    enter = function() end,
                                    haslicense = function() return true end,
                                    _verify = function(...) return true end,
                                },
            licenses            = [[
### Lua 5.2

Copyright (c) 1994-2014 Lua.org, PUC-Rio.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]],
            menu                = my_require("hydra.menu", nil),
            packages            = my_require("hydra.packages", nil),
            reload              = mjolnir.reload,
            resourcesdir        = module._paths().resourcePath,
            runapplescript      = my_require("hydra.runapplescript", "mjolnir._asm.hydra.applescript"),
            setosxshadows       = nil, -- see below
            settings            = my_require("hydra.settings", "mjolnir._asm.settings"),
            showabout           = module.showabout,
            tryhandlingerror    = mjolnir.showerror,
            updates             = my_require("update", nil),
            uuid                = module.uuid,
            version             = module._version(),
        },
        inspect                 = my_require("inspect", "inspect"),
        json                    = my_require("json", "mjolnir._asm.data.json"),
        logger                  = my_require("logger", nil),
        mouse                   = my_require("mouse", "mjolnir.jstevenson.cursor"),
        notify                  = my_require("notify", "mjolnir._asm.notify"),
        pasteboard              = my_require("pasteboard", "mjolnir._asm.data.pasteboard"),
        pathwatcher             = my_require("pathwatcher", "mjolnir._asm.watcher.path"),
        repl                    = { open = mjolnir.openconsole, path = module._paths().bundlePath, },
        screen                  = my_require("screen", "mjolnir.screen"),
        spaces                  = nil, -- see below
        textgrid                = my_require("textgrid", nil),
        timer                   = my_require("timer", "mjolnir._asm.timer"),
        utf8                    = my_require("utf8", "mjolnir._asm.data.utf8_53"),
        window                  = my_require("window", "mjolnir.window"),
    }

    --
    -- Some cleanup to make things more Hydra like...
    --
    _H._notifysetup = package.loaded["mjolnir._asm.notify"] ~= nil
    local battery_watcher = my_require("battery.watcher", "mjolnir._asm.watcher.battery")
    if type(battery_watcher) == "table" then
        if type(_H.battery) == "nil" then _H.battery = {} end
        _H.battery.watcher = battery_watcher
    end

    local screen_watcher = my_require("screen.watcher", "mjolnir._asm.watcher.screen")
    if type(screen_watcher) == "table" then
        if type(_H.screen) == "nil" then _H.screen = {} end
        _H.screen.watcher = screen_watcher
    end
    if type(_H.mouse) == "table" then
        _H.mouse.get = _H.mouse.position
        _H.mouse.set = function(xy) return _H.mouse.warptopoint(xy.x, xy.y) end
    end
    local undocumented = my_require("hydra.setosxshadows, spaces", "mjolnir._asm.hydra.undocumented")
    if type(undocumented) == "table" then
        _H.spaces = undocumented.spaces
        _H.hydra.setosxshadows = undocumented.setosxshadows
    end
    if type(_H.utf8) == "table" then
        _H.utf8.count = _H.utf8.len
        _H.utf8.chars = function(str)
            local t = {}
            str:gsub(utf8_53.charpatt,function(c) t[#t+1] = c end)
            return t
        end
    end
    return _H
end


-- Return Module Object --------------------------------------------------

return module

