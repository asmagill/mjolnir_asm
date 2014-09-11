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
--- If you installed this module via Luarocks, please visit the homepage above, clone the repository, and enter the following from the command line while in the `cli` subdirectory to create the command line tool:
---
--- <pre>
---     [PREFIX=/usr/local] make install
--- </pre>
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

-- Return Module Object --------------------------------------------------

internal.messagePort = internal.setup_ipc()

return mjolnir._asm.ipc

