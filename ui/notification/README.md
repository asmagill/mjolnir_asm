mjolnir._asm.ui.notification
============================

A more powerful use of Apple's built-in notifications system for Mjolnir.

This module also provides backwards compatibility with `mjolnir._asm.notify` and Hydra's `notify` command.  Even if you don't use the new methods, you really should discard `mjolnir._asm.notify` in favor of this -- under some conditions, the built in notifications for Mjolnir (updates available, `mjolnir._notify`, etc.) can cause odd behavior with `mjolnir._asm.notify`.

This module is based in part on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.ui.notification
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm.ui
$ cd mjolnir_asm.ui/notification
$ [PREFIX=/usr/local] make install
~~~

### Require

~~~lua
notification = require("mjolnir._asm.ui.notification")
~~~

### Functions

notification.new(...) -> notification

notification:show()
notification:withdraw()
notification:release()



Backwards compatibility functions:

~~~lua
notification.register(tag, fn) -> id
~~~
Registers a function to be called when an Apple notification with the given tag is clicked.

~~~lua
notification.show(title, subtitle, text, tag)
~~~
Show an Apple notification. Tag is a unique string that identifies this notification; any functions registered for the given tag will be called if the notification is clicked. None of the strings are optional, though they may each be blank.

~~~lua
notification.unregister(id)
~~~
Unregisters a function to no longer be called when an Apple notification with the given tag is clicked.

~~~lua
notification.unregisterall()
~~~
Unregisters all functions registered for notification-clicks; called automatically when user config

### Variables

~~~lua
notification.registry[]
~~~
This table contains the list of registered tags and their functions.  It should not be modified directly, but instead by the `notification.register(tag, fn)` and `notification.unregister(id)` functions.

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
