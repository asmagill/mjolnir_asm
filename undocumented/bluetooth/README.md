mjolnir._asm.undocumented.bluetooth
===================================

Functions to get and set undocumented options and features within OS X.  These are undocumented features from the "private" api's for Mac OS X and are not guaranteed to work with any particular version of OS X or at all.  This code was based primarily on code samples and segments found at https://github.com/toy/blueutil.

This submodule provides access to Bluetooth power and discoverability states, and the ability to change them.

I make no promises that these will work for you or work at all with any, past, current, or future versions of OS X.  I can confirm only that they didn't crash my machine during testing under 10.10pb2. You have been warned.

For what it's worth, under my setup, getting and setting discoverability seemed to be flakey, sometimes working, sometimes not, but using it to toggle bluetooth power worked perfectly.

### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.undocumented.bluetooth
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm.undocumented
$ cd mjolnir_asm.undocumented/bluetooth
$ [PREFIX=/usr/local] make install
~~~

### Require

~~~lua
bluetooth = require("mjolnir._asm.undocumented.bluetooth")
~~~

### Functions
~~~lua
bluetooth.available() -> bool
~~~
Returns true or false, indicating whether bluetooth is available on this machine.

~~~lua
bluetooth.power() -> bool
~~~
Returns true or false, indicating whether bluetooth is enabled for this machine.

~~~lua
bluetooth.discoverable() -> bool
~~~
Returns true or false, indicating whether this machine is currently discoverable via bluetooth.

~~~lua
bluetooth.set_power(bool)
~~~
Set bluetooth power state to on (true) or off (false).

~~~lua
bluetooth.set_discoverable(bool)
~~~
Set bluetooth discoverable state to on (true) or off (false).

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
