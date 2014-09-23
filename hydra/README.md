mjolnir._asm.hydra
==================

Minor functions from Hydra and a checklist function for indicating Hydra function replacements.

This module provides some of the functionality which Hydra had regarding its environment, but aren't currently in a module of their own for various reasons.

This module is not needed for any of the submodules, and the submodules can be loaded and installed independently of this one.

This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.hydra
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm.hydra
$ cd mjolnir_asm.hydra
$ [PREFIX=/usr/local] make install
~~~

### Require

~~~lua
hydra = require("mjolnir._asm.hydra")
~~~

### Functions

~~~lua
hydra.autolaunch([arg]) -> bool
~~~
When argument is absent or not a boolean value, this function returns true or false indicating whether or not Mjolnir is set to launch when you first log in.  When a boolean argument is provided, it's true or false value is used to set the auto-launch status.

~~~lua
hydra.call(fn, ...) -> ...
~~~
Just like pcall, except that failures are handled using `mjolnir.showerror`

~~~lua
hydra.check_accessibility(shouldprompt) -> isenabled
~~~
Returns whether accessibility is enabled. If passed `true`, prompts the user to enable it.

~~~lua
hydra.exec(command) -> string
~~~
Runs a shell function and returns stdout as a string (may include trailing newline).

~~~lua
hydra.fileexists(path) -> exists, isdir
~~~
Checks if a file exists, and whether it's a directory.

~~~lua
hydra._paths() -> table
~~~
Returns a table containing the resourcePath, the bundlePath, and the executablePath for the Mjolnir application.

~~~lua
hydra.showabout()
~~~
Displays the standard OS X about panel; implicitly focuses Mjolnir.

~~~lua
hydra._version() -> number
~~~
Return the current Mjolnir version as a string.

~~~lua
hydra.uuid() -> string
~~~
Returns a newly generated UUID as a string

### Hydra Parity Check Function

~~~lua
hydra.hydra_namespace() -> table
~~~
Returns the full hydra name space replicated as closely as reasonable for Mjolnir.  Really more of a checklist then a real environment to choose to live in <grin>.

This module attempts to require modules known to provide former Hydra functionality and prints a list to the Mjolnir console indicating what modules you don't have and which Hydra modules are currently have no known replacement in Mjolnir.  If you think that an existing module does exist to cover lost functionality, but it is not represented here, please let me know and I'll add it.

This module returns a table of the Hydra namespace, as it has been able to be reconstituted with your installed modules.

** NOTE:**  While this function does load the compatible modules into memory, it does so *only when you invoke this function*.  Until and unless you call this function, no additional modules are loaded into memory.

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
