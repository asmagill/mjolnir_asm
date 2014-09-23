mjolnir._asm.ipc.cli
====================

Command line interface to [Mjolnir](https://github.com/sdegutis/mjolnir).

### Details
This command line tool requires the [mjolnir._asm.ipc](https://github.com/asmagill/mjolnir_asm.ipc) module to be installed in your system and for the following line to be added to your `init.lua` file before it will work:

    require("mjolnir._asm.ipc")

This module is based primarily code from the previous incarnation of Mjolnir (Hydra) and it's command
line utility by [Steven Degutis](https://github.com/sdegutis/).

### Luarocks Install
~~~bash
$ [PREFIX=/usr/local] luarocks [--tree=mjolnir] install mjolnir._asm.ipc.cli
~~~

### Install Manually
~~~bash
$ [PREFIX=/usr/local] make install
~~~

### Documentation
~~~bash
$ man mjolnir
~~~

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

