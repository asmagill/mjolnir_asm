mjolnir._asm.data.base64
========================

This module provides base64 encoding and decoding for Mjolnir.

Portions sourced from (https://gist.github.com/shpakovski/1902994).

### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.data.base64
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm.data
$ cd mjolnir_asm.data/base64
$ [PREFIX=/usr/local] make install
~~~

### Require

~~~lua
base64 = require("mjolnir._asm.data.base64")
~~~

### Functions

~~~lua
base64.encode(val) -> str
~~~
Returns the base64 encoding of the string provided, optionally split into lines of `width` characters per line.

~~~lua
base64.decode(str) -> val
~~~
Returns a Lua string representing the given base64 string.

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
