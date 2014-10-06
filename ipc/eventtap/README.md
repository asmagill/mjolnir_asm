mjolnir._asm.eventtap
=====================

For tapping into input events (mouse, keyboard, trackpad) for observation and possibly overriding them. **This module requires `mjolnir_asm.eventtap.event` which can be found in the eventtap/event folder of this repository.**

This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.eventtap
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm.ipc
$ cd mjolnir_asm.ipc/eventtap
$ [PREFIX=/usr/local] make install
~~~

~~~bash
$ luarocks [--tree=mjolnir] make
~~~

### Require

~~~lua
eventtap = require("mjolnir._asm.eventtap")
~~~

### Functions

~~~lua
eventtap.new(types, fn) -> eventtap
~~~
Returns a new event tap with the given function as the callback for the given event types; the eventtap not started automatically. The types param is a table which may contain values from table `mjolnir._asm.eventtap.event.types`. The event types are specified as bit-fields and are exclusively-or'ed together (see {"all"} below for why this is done.  This means { ...keyup, ...keydown, ...keyup }  is equivalent to { ...keydown }.

The callback function takes an event object as its only parameter. It can optionally return two values: if the first one is truthy, this event is deleted from the system input event stream and not seen by any other app; if the second one is a table of events, they will each be posted along with this event.

    e.g. callback(obj) -> bool[, table]

If you specify the argument `types` as the special table {"all"[, events to ignore]}, then *all* events (except those you optionally list *after* the "all" string) will trigger a callback, even events which are not defined in the [Quartz Event Reference](https://developer.apple.com/library/mac/documentation/Carbon/Reference/QuartzEventServicesRef/Reference/reference.html). The value or usefulness of these events is uncertain at this time, but perhaps a more knowledgable member of the Mjolnir community may be able to provide additional references or make something of these other events. (Event type 14, for example, *appears* to be an event posted as focus leaves the current application and then again as it enters another application, but **you have been warned** that this is merely conjecture at this point and has not been verified or tested thoroughly!)

~~~lua
eventtap:start()
~~~
Starts an event tap; must be in stopped state.

~~~lua
eventtap:stop()
~~~
Stops an event tap; must be in started state.

### Example

See the file `eventtest.lua` in this repository for a sample of using this module.  The example requires `inspect`, available via Luarocks (`luarocks install inspect`).

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
