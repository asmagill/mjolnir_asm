*Very much a work in progress, so use at your own risk right now...*


mjolnir._asm.toolkit
====================

This started as random tools I found useful in playing around with Hydra/Penknife/Mjolnir.  Now, it contains some helper functions required by some of the other modules under the ext._asm space.  I will update this documentation later, but the additions are pretty obvious. 

Some are similar to builtins, but provide features I wanted, while others are just odd bits that don't really fit anywhere else or justify a module of their own.

Probably not useful to most, but fun to create.

These have been confirmed to work under the Hydra release and patches through the begining of the name change, and *should* work with Mjolnir, as I used the format and coding in [mjolnir-io/core-window](https://github.com/mjolnir-io/core.window) as the framework.

### Install

~~~bash
$ git clone https://github.com/asmagill/mjolnir-_asm_toolkit.git ~/.hydra/ext/_asm/toolkit
$ cd ~/.hydra/ext/_asm/toolkit
$ make
~~~

### Require

~~~lua
require "ext/_asm/toolkit"
~~~

You may also need to add the following to your `.hydra/init` file (I did), but from following the discussion for Mjolnir, I don't think this will be required for that, once it's released:
~~~lua
if not string.find(package.path,";?"..os.getenv("HOME").."/.hydra/%?/init.lua;?") then
    package.path = os.getenv("HOME") .. "/.hydra/?/init.lua;" .. package.path
    package.cpath = os.getenv("HOME") .. "/.hydra/?.so;" .. package.cpath
end
~~~

### Core Functions
~~~lua
ext._asm_toolkit.shell(cmd[, raw]) -- executes 'cmd' in the user's shell environment and returns a table containing three keys: rc, stdout, and stderr. If raw is 'true', then no cleanup of stdout and stderr occurs.
ext._asm_toolkit.applescript(cmd[, raw]) -- similar to shell, but uses osascript to execute 'cmd' as AppleScript.  This is a little slower then the builtin applescript function, but returns more complete exit values.
ext._asm_toolkit.datetime(number) -- returns the date-time string given (or os.time(), if not) in my preferred format -- I couldn't get it exactly the way I wanted using lua's builtin function.
ext._asm_toolkit.hexdump(string) -- returns a hex dump of the string provided.
ext._asm_toolkit.ud2string(userdata) -- returns a binary string of the userdata provided.
~~~

### Sample
The hexdump and ud2string functions grew out of my curiosity as to what exactly was in the "userdata" chunks returned by the built-in functions.  I suppose I could have read the source code, and it's not actually as useful as it sounds, but it was fun figuring this out!
~~~lua
> print(ext._asm_toolkit.hexdump(ext._asm_toolkit.ud2string(window.focusedwindow())))
0000 : 30 BD 04 00 00 60 00 00                          : 0....`..

nil
>
~~~

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

