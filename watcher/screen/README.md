mjolnir._asm.watcher.screen
===========================

Watch for screen layout changes in Mjolnir.

This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).


### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.watcher.screen
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm.watcher
$ cd mjolnir_asm.watcher/screen
$ [PREFIX=/usr/local] make install
~~~

### Require
~~~lua
sw = require("mjolnir._asm.watcher.screen")
~~~

### Functions

~~~lua
sw.new(fn) -> watcher
~~~
Creates a new screen-watcher that can be started; fn will be called when your screen layout changes in any way, whether by adding/removing/moving monitors or like whatever.

~~~lua
sw:start() -> watcher
~~~
Starts the screen watcher, making it so fn is called each time the screen arrangement changes.

~~~lua
sw:stop() -> watcher
~~~
Stops the screen watcher's fn from getting called until started again.

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
