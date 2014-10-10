mjolnir._asm.sys.audiodevice
============================

Manipulate the system's audio devices.

This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.sys.audiodevice
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm.sys
$ cd mjolnir_asm.sys/audiodevice
$ [PREFIX=/usr/local] make install
~~~

### Require

~~~lua
audiodevice = require("mjolnir._asm.sys.audiodevice")
~~~

### Functions
~~~lua
mjolnir._asm.sys.audiodevice.current() -> table
~~~
Convenience function which returns a table with the following keys and values:
    {
        name = defaultoutputdevice():name(),
        uid = defaultoutputdevice():uid(),
        muted = defaultoutputdevice():muted(),
        volume = defaultoutputdevice():volume(),
        device = defaultoutputdevice(),
    }

~~~lua
audiodevice.alloutputdevices() -> audio[]
~~~
Returns a list of all connected output devices.

~~~lua
audiodevice.defaultoutputdevice() -> audio or nil
~~~
Gets the system's default audio device, or nil, it it does not exist.

~~~lua
audiodevice:setdefaultoutputdevice() -> bool
~~~
Sets the system's default audio device to this device. Returns true if the audio device was successfully set.

~~~lua
audiodevice:name() -> string or nil
~~~
Returns the name of the audio device, or nil if it does not have a name.

~~~lua
audiodevice:uid() -> string or nil
~~~
Returns the Unique Identifier of the audio device, or nil if it does not have a uid.

~~~lua
audiodevice:muted() -> bool or nil
~~~
Returns true/false if the audio device is muted, or nil if it does not support being muted.

~~~lua
audiodevice:setmuted(bool) -> bool
~~~
Returns true if the the device's muted status was set, or false if it does not support being muted.

~~~lua
audiodevice:volume() -> number or bool
~~~
Returns a number between 0 and 100 inclusive, representing the volume percentage. Or nil, if the audio device does not have a volume level.

~~~lua
audiodevice:setvolume(level) -> bool
~~~
Returns true if the volume was set, or false if the audio device does not support setting a volume level. Level is a percentage between 0 and 100.

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
