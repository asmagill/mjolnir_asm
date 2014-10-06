mjolnir._asm.utf8_53
=========================

Functions providing basic support for UTF-8 encodings within Mjolnir.  These functions are primarily based upon the UTF-8 Library as provided by the [Lua 5.3.alpha programming language](http://www.lua.org/work/). All I have provided is a wrapper to allow easy inclusion within the Mjolnir environment.

The following text is from the preliminary [reference documentation](http://www.lua.org/work/doc/) for the Lua 5.3.alpha programming language.

> This library provides basic support for UTF-8 encoding. It provides all its functions inside the table utf8. This library does not provide any support for Unicode other than the handling of the encoding. Any operation that needs the meaning of a character, such as character classification, is outside its scope.
>
> Unless stated otherwise, all functions that expect a byte position as a parameter assume that the given position is either the start of a byte sequence or one plus the length of the subject string. As in the string library, negative indices count from the end of the string.

See **Notes** below for how to use this module to replicate the Hydra utf8 functions `count` and `chars`.

### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.utf8_53
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm.data
$ cd mjolnir_asm.data/utf8_53
$ [PREFIX=/usr/local] make install
~~~

### Require
~~~lua
utf8_53 = require("mjolnir._asm.utf8_53")
~~~

### Functions

~~~lua
utf8_53.char(···) -> string
~~~
Receives zero or more integers, converts each one to its corresponding UTF-8 byte sequence and returns a string with the concatenation of all these sequences.

~~~lua
utf8_53.codes(s) -> position, codepoint
~~~
Returns values so that the construction
    for p, c in utf8_53.codes(s) do body end
will iterate over all characters in string s, with p being the position (in bytes) and c the code point of each character. It raises an error if it meets any invalid byte sequence.

~~~lua
utf8_53.codepoint(s [, i [, j]]) -> codepoint[, ...]
~~~
Returns the codepoints (as integers) from all characters in s that start between byte position i and j (both included). The default for i is 1 and for j is i. It raises an error if it meets any invalid byte sequence.

~~~lua
utf8_53.len(s [, i [, j]]) -> count | nil, position
~~~
Returns the number of UTF-8 characters in string s that start between positions i and @{j} (both inclusive). The default for i is 1 and for j is -1. If it finds any invalid byte sequence, returns nil plus the position of the first invalid byte.

~~~lua
utf8_53.offset(s, n [, i]) -> position
~~~
Returns the position (in bytes) where the encoding of the n-th character of s (counting from position i) starts. A negative n gets characters before position i. The default for i is 1 when n is non-negative and #s + 1 otherwise, so that utf8_53.offset(s, -n) gets the offset of the n-th character from the end of the string. If the specified character is not in the subject or right after its end, the function returns nil.
As a special case, when n is 0 the function returns the start of the encoding of the character that contains the i-th byte of s.

This function assumes that s is a valid UTF-8 string.

### Variables
~~~lua
utf8_53.charpatt
~~~
The pattern (a string, not a function) "[\0-\x7F\xC2-\xF4][\x80-\xBF]*" (see §6.4.1), which matches exactly one UTF-8 byte sequence, assuming that the subject is a valid UTF-8 string.

### Notes

Hydra provided 2 UTF-8 functions which are no longer a part of the Mjolnir environment, but which can be replicated by this module.

For `hydra.utf8.count(str)` use `utf8_53.len(str)`

For `hydra.utf8.chars(str)`, which provided an array of the individual UTF-8 characters of `str`, use the following:

~~~lua
t = {} ; str:gsub(utf8_53.charpatt,function(c) t[#t+1] = c end)
~~~

### License

Lua 5.3.alpha portions covered by the Lua license: (http://www.lua.org/license.html)

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

