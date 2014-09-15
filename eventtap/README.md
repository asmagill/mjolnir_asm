mjolnir._asm.eventtap
=====================

For tapping into input events (mouse, keyboard, trackpad) for observation and possibly overriding them. This module requires [mjolnir_asm.eventtap.event](https://github.com/asmagill/mjolnir_asm.eventtap.event).

This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

### Luarocks Install
This module is not available via luarocks yet... clone the repository (or download the zip file), enter the created directory and do the following (Note that you will have to install [mjolnir_asm.eventtap.event](https://github.com/asmagill/mjolnir_asm.eventtap.event) first):

~~~bash
$ luarocks [--tree=mjolnir] make
~~~

### Require

~~~lua
eventtap = require("mjolnir._asm.eventtap")
~~~

### Functions

~~~lua
eventtap.new(types, fn) -> ignoreevent[, moreevents]) -> eventtap
~~~
Returns a new event tap with the given function as the callback for the given event type; the eventtap not started automatically. The types param is a table which may contain values from table [mjolnir_asm.eventtap.event.types](https://github.com/asmagill/mjolnir_asm.eventtap.event). The callback function takes an event object as its only parameter. It can optionally return two values: if the first one is truthy, this event is deleted from the system input event stream and not seen by any other app; if the second one is a table of events, they will each be posted along with this event.

~~~lua
eventtap:start()
~~~
Starts an event tap; must be in stopped state.

~~~lua
eventtap:stop()
~~~
Stops an event tap; must be in started state.

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
