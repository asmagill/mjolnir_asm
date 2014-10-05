mjolnir._asm.ipc
================

Organizational repository for modules providing Inter Process Communication.

### Module Details
This module installs the necessary IPC code for using a command line tool for inspection and
manipulation of your running Mjolnir application.

See the `cli` directory for `mjolnir._asm.ipc.cli`, which provides the actual command line tool.

This module is based primarily code from the previous incarnation of Mjolnir (Hydra) and it's command
line utility by [Steven Degutis](https://github.com/sdegutis/).

### Sub Modules (See folder README.md)
The following submodules are located in this repository for organizational purposes.  In most cases, they do not require this base or the other submodules.  Where this is not the case, the README in the repository folder will make this clear and if you install them via Luarocks, dependancies will be taken care of for you.

|Module                        | Available | Description                                                                    |
|:-----------------------------|:---------:|:-------------------------------------------------------------------------------|
|mjolnir._asm.applistener      | Luarocks  | Listen to notifications sent by other apps.                                    |
|mjolnir._asm.ipc.cli          | Luarocks  | Interface with Mjolnir from the command line.                                  |
|mjolnir._asm.eventtap         | Luarocks  | For tapping into input events (mouse, keyboard, trackpad).                     |
|mjolnir._asm.eventtap.event   | Luarocks  | Functionality to inspect, modify, and create events for `mjolnir_asm.eventtap` |

**NOTE: README's for in progress modules may mention luarocks, but may or may not actually be there.  Be patient, or check the README file for how to compile them yourself.**

### Luarocks Install
If you are specifying a tree for your Mjolnir modules, make sure to specify the same one for both modules, as Luarocks will check the prerequisite requirements from the specified tree by default.

~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.ipc
$ [PREFIX=/usr/local] luarocks [--tree=mjolnir] install mjolnir._asm.ipc.cli
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm.ipc
$ cd mjolnir_asm.ipc
$ [PREFIX=/usr/local] make install
~~~

### Require
ipc = require("mjolnir._asm.ipc")

### Functions
~~~lua
mjolnir._asm.ipc.handler(str) -> value
~~~
The default handler for IPC, called by mjolnir-cli. Default implementation evals the string and returns the result.
You may override this function if for some reason you want to implement special evaluation rules for executing remote commands.
The return value of this function is always turned into a string via tostring() and returned to mjolnir-cli.
If an error occurs, the error message is returned instead.

~~~lua
ipc.get_cli_colors() -> table
~~~
Returns a table containing three keys, `initial`, `input`, and `output`, which contain the terminal escape codes to generate the colors used in the command line interface.

~~~lua
ipc.set_cli_colors(table) -> table
~~~
Takes as input a table containing one or more of the keys `initial`, `input`, or `output` to set the terminal escape codes to generate the colors used in the command line interface.  Each can be set to the empty string if you prefer to use the terminal window default.  Returns a table containing the changed color codes.

For a brief intro into terminal colors, you can visit a web site like this one (http://jafrog.com/2013/11/23/colors-in-terminal.html) (I have no affiliation with this site, it just seemed to be a clear one when I looked for an example... you can use Google to find many, many others).  Note that Lua doesn't support octal escapes in it's strings, so us `\x1b` or `\27` to indicate the `escape` character.

    e.g. ipc.set_cli_colors{ initial = "", input = "\27[33m", output = "\27[38;5;11m" }

~~~lua
ipc.reset_cli_colors()
~~~
Erases any color changes you have made and resets the terminal to the original defaults.

### License

> Released under MIT license.
>
> Copyright (c) 2014 Aaron Magill
>
> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
>
