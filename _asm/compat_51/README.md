mjolnir._asm.compat_51
======================

Provides Lua 5.1 compatibility features left out of the Lua 5.2 library included with [Mjolnir](http://mjolnir.io).
Because new code should be written to the 5.2 specification, you should probably
only enable these functions as required, and disable them when not absolutely necessary.

### Details
The Lua 5.2 engine included with [Mjolnir](http://mjolnir.io) does not include the Lua 5.1 deprecated functions in it's build.  I actually agree with this because new code should be written to a current standard and updates should be encouraged.

However, this is not always possible, and many modules exist which *almost* work under Lua 5.2, but just need a few supporting functions to continue to be viable.

Here I have attempted to replicate the compatibility functions within the Lua 5.2.3 source code as a separate module so that they can be added as needed, and removed when not.  This code is almost entirely from the Lua 5.2.3 source (http://www.lua.org/download.html) and is just packaged for convenience.

The following Lua 5.1 functions and variables are "created" when the `enable` function is invoked:

* loadstring(*string* [, *chunk*])
* math.log10(*number*)
* module(*name* [, ...])
* package.seeall(*module*)
* package.loaders
* table.maxn(*table*)
* unpack(*list* [, *i* [, *j*]])

See (http://www.lua.org/manual/5.2/manual.html#8) for more details.

### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.compat_51
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm._asm
$ cd mjolnir_asm._asm/compat_51
$ [PREFIX=/usr/local] make install
~~~

### Require
~~~lua
local lua51 = require("mjolnir._asm.compat_51")
~~~

### Functions
~~~lua
lua51.enable() -- Enable Lua 5.1 Compatibility features by adding the appropriate functions into the expected globals.
lua51.disable() -- Disable Lua 5.1 Compatibility features by removing them from the global namespace.
lua51.pcall(f,...) -- Perform pcall in a Lua 5.1 compatible environment.  Lua 5.1 compatibility remains the same as it was prior to the call when it is completed (i.e. if it was already on, it stays on, if it was off, it's turned back off.)
~~~

### Variables
~~~lua
lua51.status -- Boolean variable indicating whether or not Lua 5.1 compatibility functions are enabled or not.
~~~

### Caveats
I have not yet tested any Lua 5.1 modules or luarocks which require the C side of the functions, but they are included in the [Homebrew](http://brew.sh) version of Lua 5.2, so the include files *should* provide the appropriate macros and hopefully require minimal additions here... I will update as I come across this.

In the meantime, let me know how your experiences go.

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

