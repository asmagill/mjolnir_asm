mjolnir._asm.data.base64
========================
This module provides access to the OS X clipboard from within Mjolnir.

This module is based partially on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

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
data.pasteboard.changecount() -> number
~~~
The number of times the pasteboard owner changed
(useful to see if the pasteboard was updated, by seeing if the value of this function changes).

~~~lua
data.pasteboard.getcontents() -> string
~~~
Returns the contents of the pasteboard as a string, or nil if it can't be done

~~~lua
data.pasteboard.setcontents(string) -> boolean
~~~
Sets the contents of the pasteboard to the string value passed in.  Returns success status as true or false.

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
