mjolnir._asm.settings
=====================

Functions for user-defined settings that persist across Hydra launches.

This module is based on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.settings
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm.settings
$ cd mjolnir_asm.settings
$ [PREFIX=/usr/local] make install
~~~

### Require

~~~lua
settings = require("mjolnir._asm.settings")
~~~

### Functions

~~~lua
settings.set(key, val)
~~~
Saves the given value for the string key; value must be a string, number, boolean, nil, or a table of any of these, recursively.

~~~lua
settings.get(key) -> val
~~~
Gets the Lua value for the given string key.

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
