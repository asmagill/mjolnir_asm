mjolnir._asm.modules
====================

Functions to get information about, install, and remove luarocks for installed mjolnir
modules. While it is tailored specifically to use with the mjolnir modules, it should
work with luarocks in general.

### Details
This is very basic, and experimental. Note that any luarocks compatible arguments
specified after the tree for remove and install are passed in as is, so format
accordingly, and very few cases have been tested so far, so it's still very beta!

These tools assume a default Luarocks tree named "mjolnir" exists.  You can always
specify a different tree name if you wish.  To use the "mjolnir" tree, make sure
something like the following is in your `~/.luarocks/config.lua` file:

    rocks_trees = {
        { name = [[user]], root = home..[[/.luarocks]] },
        { name = [[mjolnir]], root = home..[[/.mjolnir/rocks]] },
        { name = [[system]], root = [[/usr/local]] },
    }

Note that this ends up loading practically all of the luarocks modules into memory
and may leave Mjolnir in an inconsistent state concerning available modules.  You
should probably only require this module when you specifically want it, and then
run mjolnir.reload() when done.

To change the default tree from "mjolnir" to something else, you can use the module's
`default_tree` variable (see below), or to make it permanent, create a file in your
`.mjolnir` directory named `.mjolnir._asm.modules.lua` and put the following into it
(change "mjolnir" to match your preferred default tree):

    return {
         -- default_tree: is the luarocks tree to use by default
         default_tree = "mjolnir",
    }

### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.modules
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm._asm
$ cd mjolnir_asm._asm/modules
$ [PREFIX=/usr/local] make install
~~~

### Require
~~~lua
modules = require("mjolnir._asm.modules")
~~~

### Functions
~~~lua
mjolnir._asm.modules.trees([name]) -> table
~~~

Returns a table of the luarocks tree definition name, or all of the tree definitions
if name is not provided.

~~~lua
mjolnir._asm.modules.installed([tree]) -> table
~~~

Returns a table containing the luarocks manifest of installed modules for a tree.
If tree is absent, it defaults to the "mjolnir" tree.  If tree is --all, then it
returns the manifest for all installed modules.  Otherwise it returns the manifest
for the specified tree.

~~~lua
mjolnir._asm.modules.available([name] [, exact]) -> table
~~~

Returns a table containg the manifest of available (remote) modules which contain
name in their name.  If exact is true, then the module name must match name exactly.
If name and exact are both missing, then it returns all available modules, similar
to "luarocks search --all".

~~~lua
mjolnir._asm.modules.versions([tree]) -> table
~~~

Returns a table containing the list of modules in the specified tree (if tree is absent,
then default to tree "mjolnir"; if tree is --all, then all available trees) with the
following atributes:
    installed = the version string for the installed version
    available = the latest version string available for download
    local_only = a boolean indicating that the module does not appear in any known repository
    upgrade = a boolean indicating if the available version is greater than the installed one
    
~~~lua
mjolnir._asm.modules.remove(name, [tree [, ...]]) -> boolean [, error]
~~~

Tries to remove the specified module from the specified tree (defaults to mjolnir).
If other arguments are provided after tree, they are passed into luarocks as is,
so format accordingly. Returns true or false indicating success or failure.

~~~lua
mjolnir._asm.modules.install(name, [tree [, ...]]) -> name, version | false, error
~~~

Tries to install the specified module into the specified tree (defaults to mjolnir).
If other arguments are provided after tree, they are passed into luarocks as is,
so format accordingly. Returns the name and version of the module installed, if successful.

~~~lua
mjolnir._asm.modules.sorted_versions(manifestdata [, desc]) -> table
~~~

Returns a sorted array of the versions available in the manifest data provided.
This manifest data is a specific module's result value from a search.  If desc
is true return the list in descending order; otherwise in ascending order.

~~~lua
mjolnir._asm.modules.output([n]) -> string
~~~
Because Luarocks outputs most of it's status and errors via io.stdout:write(),
we capture the stderr and stdout streams during module install and removal. This
function returns the output of the most recent - n install or remove.  When n is
not provided, it is 0, resulting in the most recent install or remove.

### Variables

~~~lua
mjolnir._asm.modules.default_tree = string
~~~
By default, this module assumes the default luarocks tree is "mjolnir".  You
can set this variable to another value if you wish the default tree to be
something else.
If you want to permanently change the default tree to something else, create
a file in your .mjolnir/ directory named ".mjolnir._asm.modules.lua" and put
the following into it (change "mjolnir" to match your preferred default tree):

    return {
        -- default_tree: is the luarocks tree to use by default
        default_tree = "mjolnir",
    }

~~~lua
mjolnir._asm.modules.output[]
~~~
Because Luarocks outputs most of it's status and errors via io.stdout:write(),
we capture the stderr and stdout streams during module install and removal. To
see the full output of the last install or remove invocation, just look at the
end of this array, i.e.

    print(mjolnir._asm.modules.output[#mjolnir._asm.modules.output])

### Command Line
The `mjolnir-tools` file is a command-line tool which is installed into your tree bin
directory (`~/.mjolnir/rocks/bin`, if you use the mjolnir tree as shown above).  To use
this utility, make sure that the directory is in your shell's PATH or copy/link the file
to somewhere that is.

~~~bash
$ mjolnir-tool report
~~~

    Tree: mjolnir   Flags: -oal
    Module                          Installed   Latest      Status    
    ------------------------------------------------------------------
    mjolnir.7bits.mjomatic                      0.1-1       available 
    mjolnir._asm.compat_51          0.1-1                   local     
    mjolnir._asm.modules            0.1-1                   local     
    mjolnir._asm.toolkit            0.1-1                   local     
    mjolnir.cmsj.caffeinate                     0.1-1       available 
    mjolnir.hotkey                  0.2-1       0.3-1       outdated  
    mjolnir.lb.spotify                          0.1-1       available 

See `mjolnir-tool help` and `mjolnir-tool examples` for more examples.

### Notes
This module does require `mjolnir._asm.compat_51`.

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

