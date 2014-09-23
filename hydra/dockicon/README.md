mjolnir._asm.hydra.dockicon
===========================

Functions for controlling Mjolnir's own dock icon.

This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.hydra.dockicon
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm.hydra
$ cd mjolnir_asm.hydra/dockicon
$ [PREFIX=/usr/local] make install
~~~

### Require

~~~lua
dockicon = require("mjolnir._asm.hydra.dockicon")
~~~

### Functions

~~~lua
dockicon.visible() -> bool
~~~
Returns whether Mjolnir has a Dock icon, and thus can be switched to via Cmd-Tab.

~~~lua
dockicon.show()
~~~
Shows Mjolnir's dock icon; Mjolnir can then be switched to via Cmd-Tab.

~~~lua
dockicon.hide()
~~~
Hides Mjolnir's dock icon; Mjolnir will no longer show up when you Cmd-Tab.

~~~lua
dockicon.bounce([indefinitely])
~~~
Bounces Mjolnir's dock icon; if indefinitely is true, won't stop until you click the dock icon.

~~~lua
dockicon.setbadge(str)
~~~
Set's Mjolnir's dock icon's badge to the given string; pass an empty string to clear it.

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
