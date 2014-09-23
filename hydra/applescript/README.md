mjolnir._asm.hydra.applescript
==============================

Functions for executing AppleScript from within Mjolnir.

This module is based on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.hydra.applescript
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm.hydra
$ cd mjolnir_asm.hydra/applescript
$ [PREFIX=/usr/local] make install
~~~

### Require

~~~lua
applescript = require("mjolnir._asm.hydra.applescript")
~~~

### Functions

~~~lua
applescript.applescript(string) -> bool, result
~~~
May also be invoked as `applescript(string)`.

Runs the given AppleScript string. If it succeeds, returns true, and the result as a string or number (if it can identify it as such) or  as a string describing the NSAppleEventDescriptor result; if it fails, returns false and an array containing the error dictionary describing why.

Use `applescript._applescript(string)` if you always want the result as a string describing the NSAppleEventDescriptor result.

*NOTE: Result is not exactly like Hydra's, as I'm trying to work out how to provide a better result for non-string results, but it should be the same for scripts that return a number or string as their result.  I still hope to clean up object results, which were not possible with Hydra's applescript.*

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
