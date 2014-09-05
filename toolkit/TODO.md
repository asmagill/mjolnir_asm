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


