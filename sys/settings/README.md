mjolnir._asm.settings
=====================

Home: https://github.com/asmagill/mjolnir_asm.sys

Functions for manipulating user defaults for the Mjolnir application, allowing for the creation of user-defined settings which persist across Mjolnir launches and reloads.  Settings must have a string key and must be made up of serializable Lua objects (string, number, boolean, nil, tables of such, etc.)

This module is based partially on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

This module also requires `mjolnir._asm` for NSObject traversal.

### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.settings
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm.sys
$ cd mjolnir_asm.sys/settings
$ [PREFIX=/usr/local] make install
~~~

### Require

~~~lua
settings = require("mjolnir._asm.settings")
~~~

### Functions

~~~lua
settings.clear(key) -> bool
~~~
Attempts to remove the given string key from storage, returning `true` on success or `false` on failure (e.g. `key` does not exist or is administratively managed).

~~~lua
settings.get(key) -> val
~~~
Gets the Lua value for the given string key.  This function can retrieve NSUserDefault types of Data and Date, as well as serializable Lua types.

~~~lua
settings.getkeys() -> []
~~~
Returns a table of all defined keys within the Mjolnir user defaults, as an array and as a list of keys.  Use `ipairs(settings.getkeys())` to iterate through the list of all settings which have been defined or `settings.getkeys()["key"]` to test for the existence of a key.

~~~lua
settings.set(key, val)
~~~
Saves the given value for the given string key; value must be a string, number, boolean, nil, or a table of any of these, recursively.  This function cannot set NSUserDefault types of Data or Date.  See `settings.set_data` and `settings.set_date`.

The following functions allow the setting of arbitrary data and dates as values which conform to the specifications expected by other applications which may have access to the defaults stored in org.degutis.Mjolnir.

~~~lua
settings.set_data(key, val)
~~~
Saves the given value as raw binary data for the string key.  A raw binary string differs from a traditional string in that it may contain embedded null values and other unprintable bytes (characters) which might otherwise be lost or mangled if treated as a traditional C-Style (null terminated) string.

~~~lua
settings.set_date(key, val)
~~~
Saves the given value as a date for the given string key.  If val is a number, then it represents the number of seconds since 1970-01-01 00:00:00 +0000 (e.g. `os.time()`).  If it is a string, it should be in the format of 'YYYY-MM-DD HH:MM:SS ±HHMM' (e.g. `os.date("%Y-%m-%d %H:%M:%S %z")`).

### Known Limitations

1. Currently, a table with both numeric and non-numeric keys must have the numeric portion as a non-sparse array starting at 1.  This means that trying to do `settings.set("test",{[2] = true, a = true})` will fail, but `settings.set("test",{ true, true, true, a = true})` will succeed.
2. Table keys *must* be numeric (and non-sparse) and/or string values. No `{ [{}] = "my index is a table" }` allowed.
3. Looped tables will send this into a tailspin and crash Mjolnir. (e.g. `a = { k1 = 1, k2 = 2} ; a[3] = a ; settings.set("a", a)` will crash.)
4. Tables which have elements which point to the same subtables will replicate the subtables when stored.  (e.g. `b = {1,2,3} ; a = {b,b} ; settings.set("a", a)` will result in actually saving ((1,2,3),(1,2,3)).  When retrieved via `settings.get`, the subtables will be *separate* tables.

Issues 1 and 2 I hope to address when `mjolnir._asm.encoders.json` is completed.
Issues 3 and 4 I am still thinking about the best way to tackle, but will likely be address once 1 and 2 are done.

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
