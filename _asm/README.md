mjolnir._asm
============

Organizational repository for modules providing compatibility, shared libraries, or other things that "just don't quite fit" anywhere else yet.

### Module Details
At present this module does not provide any direct functionality which can be included in your Lua scripts, but it does contain C functions which are used in other modules and are contained here for easy maintenance and bug fixes.  I will provide further documentation at a later date, but unless you're coding your own modules and linking external libraries, you don't need to worry about this module -- it will be installed if another module requires it and the necessary functions will be loaded only when required.

### Sub Modules (See folder README.md)
The following submodules are located in this repository for organizational purposes.  In most cases, they do not require this base or the other submodules.  Where this is not the case, the README in the repository folder will make this clear and if you install them via Luarocks, dependancies will be taken care of for you.

|Module                 | Available | Description                                                                        |
|:----------------------|:---------:|:-----------------------------------------------------------------------------------|
|mjolnir._asm.compat_51 | Luarocks  | Provides Lua 5.1 compatibility features left out of the Lua 5.2 library in Mjolnir |
|mjolnir._asm.modules   | Luarocks  | Functions to capture info about, install and remove luarocks for mjolnir modules.  |
|mjolnir._asm.notify    | Luarocks  | Apple's built-in notifications system.                                             |

**NOTE: README's for in progress modules may mention luarocks, but may or may not actually be there.  Be patient, or check the README file for how to compile them yourself.**

Common functions and helpers for `mjolnir._asm` modules.

### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm._asm
$ cd mjolnir_asm._asm
$ [PREFIX=/usr/local] make install
~~~

### Require

~~~lua
require("mjolnir._asm")
~~~

### Functions

Testing for access to extern c functions.

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
