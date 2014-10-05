mjolnir._asm.data
=================

Functions for data encoding and decoding data within Mjolnir.  This module contains a variety
of modules that were separated in Hydra, but seemed too small/somewhat related enough that
combining them seemed reasonable.

This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

### Special Note
In keeping with the Mjolnir penchant for minimalism in it's modules, if you've used this module before, you'll notice that I have broken this module up into separate modules, with this core acting as an organizational focus and repository for a handful of related functions which don't really fit anywhere else.

### Sub Modules (See folder README.md)
The following submodules are located in this repository for organizational purposes.  In most cases, they do not require this base or the other submodules.  Where this is not the case, the README in the repository folder will make this clear and if you install them via Luarocks, dependancies will be taken care of for you.

|Module                        | Available | Description                                                                |
|:-----------------------------|:---------:|:---------------------------------------------------------------------------|
|mjolnir._asm.data.base64      | Luarocks  | This module provides base64 encoding and decoding for Mjolnir.             |
|mjolnir._asm.data.json        | Luarocks  | This module provides JSON encoding and decoding for Mjolnir.               |
|mjolnir._asm.data.pasteboard  | Luarocks  | This module provides access to the OS X clipboard from within Mjolnir.     |
|mjolnir._asm.utf8_53          | Luarocks  | Functions providing basic support for UTF-8 encodings within Mjolnir.      |

**NOTE: README's for in progress modules may mention luarocks, but may or may not actually be there.  Be patient, or check the README file for how to compile them yourself.**

### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.data
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm.data
$ cd mjolnir_asm.data
$ [PREFIX=/usr/local] make install
~~~

### Require

~~~lua
data = require("mjolnir._asm.data")
~~~

### Functions

~~~lua
data.hexdump(string [, count]) -> string
~~~
Treats the input string as a binary blob and returns a prettied up hex dump of it's contents. By default, a newline character is inserted after every 16 bytes, though this can be changed by also providing the optional count argument.

~~~lua
data.userdata_tostring(userdata) -> string
~~~
Returns the userdata object as a binary string.

~~~lua
data.uuid() -> string
~~~
Returns a newly generated UUID as a string

### Variables

~~~lua
data.applekeys[...]
~~~
Array of symbols representing special keys in the mac environment, as per http://macbiblioblog.blogspot.com/2005/05/special-key-symbols.html.

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
