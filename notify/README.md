mjolnir._asm.notify
===================

Description

### Install

If you wish to install this from Luarocks, do the following:

~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.notify
~~~

If you wish to install this yourself, clone the repository and do the following:

~~~bash
$ make install
~~~

### Require

~~~lua
notify = require("mjolnir._asm.notify")
~~~

### Functions

~~~lua
notify.show(title, subtitle, text, tag)
~~~
Show an Apple notification. Tag is a unique string that identifies this notification; any functions registered for the given tag will be called if the notification is clicked. None of the strings are optional, though they may each be blank.

~~~lua
notify.register(tag, fn) -> id
~~~
Registers a function to be called when an Apple notification with the given tag is clicked.

~~~lua
notify.unregister(id)
~~~
Unregisters a function to no longer be called when an Apple notification with the given tag is clicked.

~~~lua
notify.unregisterall()
~~~
Unregisters all functions registered for notification-clicks; called automatically when user config 

### Variables

~~~lua
notify.registry[]
~~~
This table contains the list of registered tags and their functions.  It should not be modified directly, but instead by the mjolnir._asm.notify.register(tag, fn) and mjolnir._asm.notify.unregister(id) functions.

### Special Notes

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
