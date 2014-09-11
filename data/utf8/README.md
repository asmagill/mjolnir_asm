Hydra
-----
utf8

Utilities for handling UTF-8 strings 'correctly'.

chars

utf8.chars(str) -> {str, ...}
Splits the string into groups of (UTF-8 encoded) strings representing what humans would consider individual characters.

The result is a sequential table, such that table.concat(result) produces the original string.

count

utf8.count(str) -> int
Returns the number of characters as humans would count them.



Lua 5.3
-------

This library provides basic support for UTF-8 encoding. It provides all its functions inside the table utf8. This library does not provide any support for Unicode other than the handling of the encoding. Any operation that needs the meaning of a character, such as character classification, is outside its scope.

Unless stated otherwise, all functions that expect a byte position as a parameter assume that the given position is either the start of a byte sequence or one plus the length of the subject string. As in the string library, negative indices count from the end of the string.

utf8.char (···)

Receives zero or more integers, converts each one to its corresponding UTF-8 byte sequence and returns a string with the concatenation of all these sequences.
utf8.charpatt

The pattern (a string, not a function) "[\0-\x7F\xC2-\xF4][\x80-\xBF]*" (see §6.4.1), which matches exactly one UTF-8 byte sequence, assuming that the subject is a valid UTF-8 string.
utf8.codes (s)

Returns values so that the construction

     for p, c in utf8.codes(s) do body end
will iterate over all characters in string s, with p being the position (in bytes) and c the code point of each character. It raises an error if it meets any invalid byte sequence.

utf8.codepoint (s [, i [, j]])

Returns the codepoints (as integers) from all characters in s that start between byte position i and j (both included). The default for i is 1 and for j is i. It raises an error if it meets any invalid byte sequence.
utf8.len (s [, i [, j]])

Returns the number of UTF-8 characters in string s that start between positions i and @{j} (both inclusive). The default for i is 1 and for j is -1. If it finds any invalid byte sequence, returns nil plus the position of the first invalid byte.
utf8.offset (s, n [, i])

Returns the position (in bytes) where the encoding of the n-th character of s (counting from position i) starts. A negative n gets characters before position i. The default for i is 1 when n is non-negative and #s + 1 otherwise, so that utf8.offset(s, -n) gets the offset of the n-th character from the end of the string. If the specified character is not in the subject or right after its end, the function returns nil.
As a special case, when n is 0 the function returns the start of the encoding of the character that contains the i-th byte of s.

This function assumes that s is a valid UTF-8 string.

https://github.com/starwing/luautf8
-----------------------------------
UTF-8 module for Lua 5.x
========================

This module is add UTF-8 support to Lua.

It use data extracted from Unicode Character Database[1], and tested on Lua
5.2.3 and LuaJIT.

parseucd.lua is a pure Lua script generate unidata.h, to support convert
characters and check characters' category.

It mainly used to compatible with Lua's own string module, it passed all
string and pattern matching test in lua test suite[2].

It also add some useful routines against UTF-8 features, some like:
  - a convenient interface to escape Unicode sequence in string. 
  - string insert/remove, since UTF-8 substring extract may expensive.
  - calculate Unicode width, useful when implement e.g. console emulator.
  - a useful interface to translate Unicode offset and byte offset.

[1]: http://www.unicode.org/reports/tr44/
[2]: http://www.lua.org/tests/5.2/


Install:

Just compile lutf8lib.c with you favourite compiler:
  on windows:
    gcc -mdll -O3 -DLUA_BUILD_AS_DLL -I/path/to/lua/include lutf8lib.c -o utf8.dll -llua52
  on linux:
    gcc -shared -O3 lutf8lib.c -o utf8.so


Usage:

Many routines are same as Lua's string module:
  - utf8.byte
  - utf8.char
  - utf8.find
  - utf8.gmatch
  - utf8.gsub
  - utf8.len
  - utf8.lower
  - utf8.match
  - utf8.reverse
  - utf8.sub
  - utf8.upper

  The document of these functions can be find in Lua manual[3].

[3]: http://www.lua.org/manual/5.2/manual.html#6.4


Some routines in string module needn't support Unicode:
  - string.dump
  - string.format
  - string.rep

  They are NOT in utf8 module.


Some routines are new, with some Unicode-spec functions:

utf8.escape(str) -> utf8 string
    escape a str to UTF-8 format string. It support several escape format:

      %ddd - which ddd is a decimal number at any length:
             change Unicode code point to UTF-8 format.
      %{ddd} - same as %nnn but has bracket around.
      %uddd - same as %ddd, u stands Unicode
      %u{ddd} - same as %{ddd}
      %xhhh - hexadigit version of %ddd
      %x{hhh} same as %xhhh.
      %? - '?' stands for any other character: escape this character.

    Examples:
      local u = utf8.escape
      print(u"%123%u123%{123}%u{123}%xABC%x{ABC}")
      print(u"%%123%?%d%%u")


utf8.charpos(s[[, charpos], offset]) -> charpos, code point
    convert UTF-8 position to byte offset.
    if only offset is given, return byte offset of this UTF-8 char index.
    if charpos and offset is given, a new charpos will calculate, by
    add/subtract UTF-8 char offset to current charpos.
    in all case, it return a new char position, and code point (a number) at
    this position.

utf8.next(s[, charpos[, offset]]) -> charpos, code point
    iterate though the UTF-8 string s.
    If only s is given, it can used as a iterator:
      for pos, code in utf8.next, "utf8-string" do
         -- ...
      end
    if only charpos is given, return the next byte offset of in string.
    if charpos and offset is given, a new charpos will calculate, by
    add/subtract UTF-8 char offset to current charpos.
    in all case, it return a new char position, and code point (a number) at
    this position.


utf8.insert(s[, idx], substring) -> new_string
    insert a substring to s. If idx is given, insert substring before char at
    this index, otherwise substring will concat to s. idx can be negative.


utf8.remove(s[, start[, stop]]) -> new_string
    delete a substring in s. If neither start nor stop is given, delete the
    last UTF-8 char in s, otherwise delete char from start to end of s. if
    stop is given, delete char from start to stop (include start and stop).
    start and stop can be negative.


utf8.width(s[, ambi_is_double[, default_width]]) -> width
    calculate the width of UTF-8 string s. if ambi_is_double is given, the
    ambiguous width character's width is 2, otherwise it's 1.
    fullwidth/doublewidth character's width is 2, and other character's width
    is 1.
    if default_width is given, it will be the width of unprintable character,
    used display a non-character mark for these characters.
    if s is a code point, return the width of this code point.


utf8.widthindex(s, location[, ambi_is_double[, default_width]]) -> idx, offset, width
    return the character index at given location in string s. this is a
    reverse operation of utf8.width().
    this function return a index of location, and a offset in in UTF-8
    encoding. e.g. if cursor is at the second column (middle) of the wide
    char, offset will be 2. the width of character at idx is returned, also.


utf8.title(s) -> new_string
utf8.fold(s) -> new_string
    convert UTF-8 string s to title-case, or folded case used to compare by
    ignore case.
    if s is a number, it's treat as a code point and return a convert code
    point (number). utf8.lower/utf8.upper has the same extension.


utf8.ncasecmp(a, b) -> [-1,0,1]
    compare a and b without case, -1 means a < b, 0 means a == b and 1 means a > b.


Improvement needed:
  - more test case.
  - grapheme-compose support, and affect in utf8.reverse and utf8.width
  - Unicode normalize algorithm implement.


License:

  It use same license with Lua: http://www.lua.org/license.html

