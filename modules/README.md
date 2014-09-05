mjolnir._asm.modules
====================

Functions to get information about, install, and remove luarocks for installed mjolnir
modules. While it is tailored specifically to use with the mjolnir modules, it should
work with luarocks in general.

### Details
This is very basic, and experimental. Note that any luarocks compatible arguments
specified after the tree for remove and install are passed in as is, so format
accordingly, and very few cases have been tested so far, so it's still very beta!

Note that this ends up loading practically all of the luarocks modules into memory
and may leave Mjolnir in an inconsistent state concerning available modules.  You
should probably only require this module when you specifically want it, and then
run mjolnir.reload() when done.

These tools assume a default Luarocks tree named "mjolnir" exists.  You can always
specify a different tree name if you wish.  To use the "mjolnir" tree, make sure
something like the following is in your `~/.luarocks/config.lua` file:

    rocks_trees = {
            { name = [[user]], root = home..[[/.luarocks]] },
            { name = [[mjolnir]], root = home..[[/.mjolnir/rocks]] },
            { name = [[system]], root = [[/usr/local]] },
    }

The `mjolnir-tools` file is a command-line tool which is installed into your tree bin
directory (~/.mjolnir/rocks/bin, if you use the mjolnir tree as shown here).  To use
this utility, make sure that the directory is in your shell's PATH or copy/link the file
to somewhere that is.

### Install
Soon, this should be available via luarocks at (https://rocks.moonscript.org/), but for now, clone this repository and execute the following in the modules directory:

~~~bash
$ luarocks [--tree=mjolnir] make
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

### Notes
This does require `mjolnir._asm.compat_51`.

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

