mjolnir._asm.hydra.undocumented
================================


### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.hydra.undocumented
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm.hydra
$ cd mjolnir_asm.hydra/undocumented
$ [PREFIX=/usr/local] make install
~~~

### Require

~~~lua
undocumented = require("mjolnir._asm.hydra.undocumented")
~~~

### Functions

~~~lua
undocumented.spaces_count() -> number
~~~
The number of spaces you currently have.

~~~lua
undocumented.spaces_currentspace() -> number
~~~
The index of the space you're currently on, 1-indexed (as usual).

~~~lua
undocumented.spaces_movetospace(number)
~~~
Switches to the space at the given index, 1-indexed (as usual).

Note that this may cause unexpected or odd behavior in spaces changes under 10.9 and 10.10.  A more robust solution is being looked into.

~~~lua
mjolnir._asm.hydra.undocumented.setosxshadows(bool)
~~~
Sets whether OSX apps have shadows.

### Variables

~~~lua
undocumented.spaces[]
~~~
Convenience module `spaces` containing just the Hydra spaces modules for Mjolnir with simplified names.

    spaces = require("mjolnir._asm.hydra.undocumented").spaces

    spaces.count()         -- see spaces_count()
    spaces.currentspace()  -- see spaces_currentspace()
    spaces.movetospace(#)  -- see spaces_movetospace(#)

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
