if not mjolnir._asm then mjolnir._asm = {} end

mjolnir._asm.ipc = {
--[=[
    _NAME        = 'mjolnir.module_name',
    _VERSION     = 'the 1st digit of Pi/0',
    _URL         = 'https://github.com/asmagill/mjolnir_asm',
    _LICENSE     = [[ See README.md ]]
    _DESCRIPTION = [[

--- === mjolnir._asm.ipc ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.ipc
---
--- Interface with Mjolnir from the command line.
---
--- To install the command line tool, you also need to install `mjolnir._asm.ipc.cli`.
---
--- This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

    ]],
--]=]
}

local internal = require("mjolnir._asm.ipc.internal")
local internal_mt = {
    __gc = function(...)
        if internal.messagePort then
            internal.invalidate_ipc(internal.messagePort)
        end
    end
}
setmetatable(internal, internal_mt)

-- private variables and methods -----------------------------------------

local fakestdout = ""
local function ipcprint(...)
  local things = table.pack(...)
  for i = 1, things.n do
    if i > 1 then fakestdout = fakestdout .. "\t" end
    fakestdout = fakestdout .. tostring(things[i])
  end
  fakestdout = fakestdout .. "\n"
end

local function rawhandler(str)
  local fn, err = load("return " .. str)
  if not fn then fn, err = load(str) end
  if fn then return fn() else return err end
end

-- Public interface ------------------------------------------------------

--- mjolnir._asm.ipc.handler(str) -> value
--- Function
--- The default handler for IPC, called by mjolnir-cli. Default implementation evals the string and returns the result.
--- You may override this function if for some reason you want to implement special evaluation rules for executing remote commands.
--- The return value of this function is always turned into a string via tostring() and returned to mjolnir-cli.
--- If an error occurs, the error message is returned instead.
mjolnir._asm.ipc.handler = rawhandler

function mjolnir._asm.ipc._handler(raw, str)
  local originalprint = print
  fakestdout = ""
  print = function(...) originalprint(...) ipcprint(...) end

  local fn = mjolnir._asm.ipc.handler
  if raw then fn = rawhandler end
  local results = table.pack(pcall(function() return fn(str) end))

  local str = fakestdout .. tostring(results[2])
  for i = 3, results.n do
    str = str .. "\t" .. tostring(results[i])
  end

  print = originalprint
  return str
end

--- mjolnir._asm.ipc.get_cli_colors() -> table
--- Function
---Returns a table containing three keys, `initial`, `input`, and `output`, which contain the terminal escape codes to generate the colors used in the command line interface.
mjolnir._asm.ipc.get_cli_colors = function()
	local settings = require("mjolnir._asm.settings")
	local colors = {}
	colors.initial = settings.get("_asm.ipc.cli.color_initial") or "\27[35m" ;
	colors.input = settings.get("_asm.ipc.cli.color_input") or "\27[34m" ;
	colors.output = settings.get("_asm.ipc.cli.color_output") or "\27[36m" ;
	return colors
end

--- mjolnir._asm.ipc.set_cli_colors(table) -> table
--- Function
--- Takes as input a table containing one or more of the keys `initial`, `input`, or `output` to set the terminal escape codes to generate the colors used in the command line interface.  Each can be set to the empty string if you prefer to use the terminal window default.  Returns a table containing the changed color codes.
---
--- For a brief intro into terminal colors, you can visit a web site like this one (http://jafrog.com/2013/11/23/colors-in-terminal.html) (I have no affiliation with this site, it just seemed to be a clear one when I looked for an example... you can use Google to find many, many others).  Note that Lua doesn't support octal escapes in it's strings, so use `\x1b` or `\27` to indicate the `escape` character.
---
---    e.g. ipc.set_cli_colors{ initial = "", input = "\27[33m", output = "\27[38;5;11m" }
mjolnir._asm.ipc.set_cli_colors = function(colors)
	local settings = require("mjolnir._asm.settings")
	if colors.initial then settings.set("_asm.ipc.cli.color_initial",colors.initial) end
	if colors.input then settings.set("_asm.ipc.cli.color_input",colors.input) end
	if colors.output then settings.set("_asm.ipc.cli.color_output",colors.output) end
	return mjolnir._asm.ipc.get_cli_colors()
end

--- mjolnir._asm.ipc.reset_cli_colors()
--- Function
--- Erases any color changes you have made and resets the terminal to the original defaults.
mjolnir._asm.ipc.reset_cli_colors = function()
	local settings = require("mjolnir._asm.settings")
	settings.clear("_asm.ipc.cli.color_initial")
	settings.clear("_asm.ipc.cli.color_input")
	settings.clear("_asm.ipc.cli.color_output")
end

-- Return Module Object --------------------------------------------------

internal.messagePort = internal.setup_ipc()

return mjolnir._asm.ipc

