mjolnir._asm.ipc
======================

A port of Hydra's ipc code to Mjolnir.

### Details
This module installs the necessary IPC code for using a command line tool for inspection and
manipulation of your running Mjolnir application.

This module is based on code from the previous incarnation of Mjolnir (Hydra) and it's command
line utility by [Steven Degutis](https://github.com/sdegutis/).

Due to uncertainty in the future of Mjolnir package management, I'm not sure the best way to
release this... I'll probably do Luarocks, once I decide how best to handle the command line tool,
but for now, there are these instructions.

### Installation

1. clone this repository.
2. If you have Luarocks installed, then type `luarocks [--tree=mjolnir] make`
3. If you do not have Luarocks, then type `make install`

To install the command line tool, enter the cli subdirectory and type `make install`

### Require
require("mjolnir._asm.ipc")

### Functions
`mjolnir._asm.ipc.handler(str) -> value`

The default handler for IPC, called by mjolnir-cli. Default implementation evals the string and returns the result.
You may override this function if for some reason you want to implement special evaluation rules for executing remote commands.
The return value of this function is always turned into a string via tostring() and returned to mjolnir-cli.
If an error occurs, the error message is returned instead.

### License

> Released under MIT license.
>
> Copyright (c) 2014 Aaron Magill
>
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in
> all copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
> THE SOFTWARE.

