mjolnir._asm.modal_hotkey
=========================

This module extends mjolnir.hotkey for conveniently binding modal hotkeys in the same manner as in Hydra.

This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

Example usage:

    k = modal_hotkey.new({"cmd", "shift"}, "d")

    function k:entered() mjolnir.alert('Entered mode') end
    function k:exited()  mjolnir.alert('Exited mode')  end

    k:bind({}, 'escape', function() k:exit() end)
    k:bind({}, 'J', function() mjolnir.alert("Pressed J") end)

### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.modal_hotkey
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm.hydra
$ cd mjolnir_asm.hydra/modal_hotkey
$ [PREFIX=/usr/local] make install
~~~

### Require
~~~lua
modal_hotkey = require("mjolnir._asm.modal_hotkey")
~~~

### Functions

~~~lua
mjolnir._asm.modal_hotkey.inject()
~~~
Injects this module into `mjolnir.hotkey` as `mjolnir.hotkey.modal`.  This is to provide bindings similar to those used in Hydra, when modal was expected to be found attached to the `hydra.hotkey` name space.  Because of the caching used by Lua with `require`, invoking this function once will cause these functions to silently be available to any other module or lua input which has required `mjolnir.hotkey`.

To activate this behavior, put the following somewhere at the top of your `~/.mjolnir/init.lua` file:

    require("mjolnir._asm.modal_hotkey").inject()

Calling this function is not a requirement to using this module; it is provided for backwards similarity/compatibility.

~~~lua
modal_hotkey:bind(mods, key, pressedfn, releasedfn)
~~~
Registers a new hotkey that will be bound when the modal is enabled.

~~~lua
modal_hotkey:enter()
~~~
Enables all hotkeys created via `modal:bind` and disables the modal itself. Called automatically when the modal's hotkey is pressed.

~~~lua
modal_hotkey:entered()
~~~
Optional callback for when a modal is entered; default implementation does nothing.

~~~lua
modal_hotkey:exit()
~~~
Disables all hotkeys created via `modal:bind` and re-enables the modal itself.

~~~lua
modal_hotkey:exited()
~~~
Optional callback for when a modal is exited; default implementation does nothing.

~~~lua
modal_hotkey.new(mods, key) -> modal
~~~
Creates a new modal hotkey and enables it. When mods and key are pressed, all keys bound via `modal:bind` will be enabled. They are disabled when the "mode" is exited via `modal:exit()`

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

