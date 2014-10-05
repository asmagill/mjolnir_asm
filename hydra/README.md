mjolnir._asm.hydra
==================

Minor functions from Hydra and a checklist function for indicating Hydra function replacements.

This module provides some of the functionality which Hydra had regarding its environment, but aren't currently in a module of their own for various reasons.

This module is not needed for any of the submodules, and the submodules can be loaded and installed independently of this one.

This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

### Sub Modules (See folder README.md)
The following submodules are located in this repository for organizational purposes.  In most cases, they do not require this base or the other submodules.  Where this is not the case, the README in the repository folder will make this clear and if you install them via Luarocks, dependancies will be taken care of for you.

|Module                          | Available | Description                                                                |
|:-------------------------------|:---------:|:---------------------------------------------------------------------------|
|mjolnir._asm.hydra.applescript  | Luarocks  | Functions for executing AppleScript from within Mjolnir.                   |
|mjolnir._asm.hydra.dockicon     | Luarocks  | Functions for controlling Mjolnir's own dock icon.                         |
|mjolnir._asm.modal_hotkey       | Luarocks  | This module extends mjolnir.hotkey for conveniently binding modal hotkeys. |
|mjolnir._asm.hydra.undocumented | Luarocks  | This module provides Hydra's `spaces` and `hydra.setosxshadows`.           |

**NOTE: README's for in progress modules may mention luarocks, but may or may not actually be there.  Be patient, or check the README file for how to compile them yourself.**

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
hydra.exec(command[, with_user_env]) -> string
~~~
Runs a shell command and returns stdout as a string (may include a trailing newline).  If `with_user_env` is `true`, then invoke the user's default shell as an interactive login shell in which to execute the provided command in order to make sure their setup files are properly evaluated so extra path and environment variables can be set.  This is not done, if `with_user_env` is `false` or not provided, as it does add some overhead and is not always strictly necessary.

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
Returns the full hydra name space replicated as closely as reasonable for Mjolnir.  Really more of a checklist then a real environment to choose to live in &lt;grin&gt;.

This module attempts to require modules known to provide former Hydra functionality and prints a list to the Mjolnir console indicating what modules you don't have and which Hydra modules are currently have no known replacement in Mjolnir.  If you think that an existing module does exist to cover lost functionality, but it is not represented here, please let me know and I'll add it.

This module returns a table of the Hydra namespace, as it has been able to be reconstituted with your installed modules.

**NOTE:**  While this function does load the compatible modules into memory, it does so *only when you invoke this function*.  Until and unless you call this function, no additional modules are loaded into memory.

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
