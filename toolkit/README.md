TODO:

1. add environment variable support to shell:
    a. mjolnir._asm.toolkit.shell(cmd, [, env] [, raw])
    b. env is a table with keys as the variable name, and the value is what to set it to
    c. don't bother with shell escapes -- that is the users job. 
    d. quotes?
    e. use the env command, if env exists, like this example:
    
    > inspect(tk.shell("env LUA_PATH='"..package.path.."' LUA_CPATH='"..package.cpath.."' printenv"))
    {
        rc = 0,
        stderr = {},
        stdout = {
            "MANPATH=/usr/local/share/man:/opt/amagill/share/man:/usr/share/man:/opt/X11/share/man:/Library/Developer/CommandLineTools/usr/share/man:/opt/node/share/man",
            "SHELL=/usr/local/bin/bash",
            "TMPDIR=/var/folders/5y/6wmtmrhj4k79vmt_pxmhsg300000gn/T/",
            "EnvAgent_vars=PATH MANPATH",
            "Apple_PubSub_Socket_Render=/private/tmp/com.apple.launchd.VBiOII4Dfk/Render",
            "USER=amagill",
            "SSH_AUTH_SOCK=/private/tmp/com.apple.launchd.eEIAZiCUJu/Listeners",
            "__CF_USER_TEXT_ENCODING=0x1F5:0x0:0x0",
            "PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin",
            "PWD=/Users/amagill/.mjolnir",
            "XPC_FLAGS=0x0",
            "XPC_SERVICE_NAME=0",
            "SHLVL=1",
            "HOME=/Users/amagill",
            "LOGNAME=amagill", 
            "DISPLAY=/private/tmp/com.apple.launchd.reHxjTlOTF/org.macosforge.xquartz:0",
            "_=/usr/bin/env", 
            "LUA_PATH=/Users/amagill/.luarocks/share/lua/5.2/?.lua;/Users/amagill/.luarocks/share/lua/5.2/?/init.lua;/usr/local/share/lua/5.2/?.lua;/usr/local/share/lua/5.2/?/init.lua;/usr/local/lib/lua/5.2/?.lua;/usr/local/lib/lua/5.2/?/init.lua;./?.lua;./?/init.lua",
            "LUA_CPATH=/Users/amagill/.luarocks/lib/lua/5.2/?.so;/usr/local/lib/lua/5.2/?.so;/usr/local/lib/lua/5.2/loadall.so;./?.so"
        }
    }

2. Redo docs to match this:

    == mjolnir._asm.toolkit ===

    Random tools/functions/holy-shiznits that might be useful somewhere someday.
    Note that some of these may let us poke around where we probably shoudln't.
    (at least that was the reason for ud2string...), so... if use, missuse,
    failure to use/misuse, or anything else causes your system, environment, or
    life to turn into a smoldering pile of molten yuckiness, just remember...
    I didn't do it, nobody saw me do it, you can't prove anything.

    mjolnir._asm.toolkit.split(div, string) -> { ... }
    Function
    Convert string to an array of strings, breaking at the specified divider(s), similar to "split" in Perl.

    mjolnir._asm.toolkit.shell(cmd [, raw]) -> { rc = # , stdout = { ... }/string, stderr = { ... }/string }
    Function
    Execute cmd in the users shell.
    If raw is false or not present, then stdout and stderr are "cleaned up" by removing leading and trailing space characters from the command output, and stdout and stderr are arrays of strings for each line of the output.
    If raw is true, then stdout and stderr are strings containing the untouched output produced.

    mjolnir._asm.toolkit.applescript(cmd [, raw]) -> { rc = # , stdout = { ... }/string, stderr = { ... }/string }
    Function
    Uses "osascript" to execute cmd as applescript. Returns rc, stdout, and stderr as per mjolnir._asm.toolkit.shell.

    mjolnir._asm.toolkit.hexdump(string [, count]) -> string
    Function
    Treats the input string as a binary blob and returns a prettied up hex dump of it's contents. By default, a newline character is inserted after every 16 bytes, though this can be changed by also providing the optional count argument.

    mjolnir._asm.toolkit.datetime(number) -> string
    Function
    takes the specified timevalue (or os.time() if not specified) and returns it in the format I like, as this wasn't quite possible with lua's builtin date support.

    mjolnir._asm.toolkit.specialkeys[...]
    Variable
    Array of symbols representing special keys in the mac environment

    mjolnir._asm.toolkit.sorted_keys(table[ , function]) -> function
    Function
    Iterator for getting keys from a table in a sorted order. Provide function 'f' as per _Programming_In_Lua,_3rd_ed_, page 52; otherwise order is ascii order ascending. Similar to sort(keys %hash) in Perl.

    mjolnir._asm.toolkit.mt_tools[...]
    Variable
    An array containing useful functions for metatables in a single location for reuse.
    Currently defined:
     table:get("path.key" [, default]) -- add to __index to retrieve a value for key at the specified path in table, or a default value, if it doesn't exist.
     table:set("path.key", value [, build]) -- add to __index to set a value for key at the specified path in table, building up the tables along the way, if build is true.

    mjolnir._asm.toolkit.userdata_to_string(userdata) -> string
    Function
    Returns the userdata object as a binary string.


_asm_toolkit
============

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

