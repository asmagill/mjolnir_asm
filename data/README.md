mjolnir._asm.data
=================

Functions for data encoding and decoding within Mjolnir.

json, uuid, and clipboard code is based on code from the previous incarnation of Mjolnir by
[Steven Degutis](https://github.com/sdegutis/).

utf-8 code is based upon the Lua 5.3 alpha specification (http://www.lua.org)

### Install

If you wish to install this from Luarocks, do the following:

~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.settings
~~~

If you wish to install this yourself, clone the repository and do the following (change PREFIX in the Makefile if you do not want this to be installed in /usr/local):

~~~bash
$ make install
~~~

### Require

~~~lua
data = require("mjolnir._asm.data")
~~~

### Functions

~~~lua
data.uuid() -> string
~~~
Returns a newly generated UUID as a string

~~~lua
data.json.encode(val[, prettyprint?]) -> str
~~~
Returns a JSON string representing the given value; if prettyprint is true, the resulting string will be quite beautiful.

~~~lua
data.json.decode(str) -> val
~~~
Returns a Lua value representing the given JSON string.

~~~lua
data.clipboard.stringcontents() -> string
~~~
Returns the contents of the pasteboard as a string, or nil if it can't be done

~~~lua
data.clipboard.changecount() -> number
~~~
The number of times the pasteboard owner changed
(useful to see if the pasteboard was updated, by seeing if the value of this function changes).

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
