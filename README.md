mjolnir_asm -- undergoing a facelift
====================================

Development space for Mjolnir modules under mjolnir._asm

---------------------
**Note that I am undergoing a re-organization of the separate repositories and location of source code for modules I have provided for Mjolnir.  Modules with names that have been submitted to Moonrocks/Luarocks will not changed, only source code locations will change.  Since I routinely upload source as well as binary rocks, this shouldn't affect you unless you have previously used Git to download these modules... those links may need to change as this irons out.**

I apologize for the inconvenience this may cause, but my number of repositories was about to get out of control.
---------------------

### Modules and Collections

*Here is a list of the modules and collections of modules and their GitHub page for review.  Check each module or collection out for a status of the released version of the modules, as this particular repository may contain things that are incomplete or broken or being updated, but aren't quite stable yet.*

|Collection                  | Description                                                            |
|:---------------------------:------------------------------------------------------------------------|
|*mjolnir._asm*              | Compatibility, standalone, shared libraries, etc.                      |
|*mjolnir._asm.data*         | Encode, decode, manipulate data, etc.                                  |
|*mjolnir._asm.hydra*        | Backwards compatibility, modules which may move if they get more work. |
|*mjolnir._asm.ipc*          | Inter process communication, command line, etc.                        |
|*mjolnir._asm.sys*          | Modify or retrieve system settings and devices.                        |
|*mjolnir._asm.undocumented* | Modules that knowingly use undocumented APIs or questionable code.     |
|*mjolnir._asm.watcher*      | Modules that act on external events; some crossover with ipc.          |

See README.md in each modules directory.

**NOTE: README's for in progress modules may mention luarocks, but probably haven't been uploaded yet, unless it's a major change or rewrite of an existing, older module.**

### License

> Released under MIT license.
>
> Copyright (c) 2014 Aaron Magill
>
> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
>
