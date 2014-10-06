mjolnir._asm.data.json
======================

This module provides JSON encoding and decoding for Mjolnir utilizing the NSJSONSerialization functions available in OS X 10.7 +

This module is based partially on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

This module also requires `mjolnir._asm` for NSObject traversal.

### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.data.json
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm.data
$ cd mjolnir_asm.data/json
$ [PREFIX=/usr/local] make install
~~~

### Require

~~~lua
json = require("mjolnir._asm.data.json")
~~~

### Functions

~~~lua
json.encode(val[, prettyprint?]) -> str
~~~
Returns a JSON string representing the given value; if prettyprint is true, the resulting string will formatted for readability.  Value must be a table.

~~~lua
json.decode(str) -> val
~~~
Returns a Lua value representing the given JSON string.

### Known Limitations

1. Table keys *must* be numeric and/or string values. No `{ [{}] = "my index is a table" }` allowed.
2. Looped tables will send this into a tailspin and crash Mjolnir. (e.g. `a = { k1 = 1, k2 = 2} ; a[3] = a ; settings.set("a", a)` will crash.)
3. Tables which have elements which point to the same subtables will replicate the subtables when stored.  (e.g. `b = {1,2,3} ; a = {b,b} ; settings.set("a", a)` will result in actually saving ((1,2,3),(1,2,3)).  When retrieved via `settings.get`, the subtables will be *separate* tables.

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
