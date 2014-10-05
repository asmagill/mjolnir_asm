mjolnir._asm.undocumented.coredock
==================================

Functions to get and set undocumented options and features within OS X.  These are undocumented features from the "private" api's for Mac OS X and are not guaranteed to work with any particular version of OS X or at all.  This code was based primarily on code samples and segments found at (https://code.google.com/p/undocumented-goodness/) and (https://code.google.com/p/iterm2/source/browse/branches/0.10.x/CGSInternal/CGSDebug.h?r=2).

This submodule provides access to CoreDock related features.  This allows you to adjust the Dock's position, pinning, hiding, magnification and animation settings.

I make no promises that these will work for you or work at all with any, past, current, or future versions of OS X.  I can confirm only that they didn't crash my machine during testing under 10.10pb2. You have been warned.

For what it's worth, under my setup, pinning seems to be completely ignored and setting the Dock to the top orientation is also ignored, though left, right, and bottom work.

### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.undocumented.coredock
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm.undocumented
$ cd mjolnir_asm.undocumented/coredock
$ [PREFIX=/usr/local] make install
~~~

### Require

~~~lua
coredock = require("mjolnir._asm.undocumented.coredock")
~~~

### Functions

~~~lua
coredock.get_animationeffect() -> int
~~~
Returns an integer indicating the animation effect used for window hiding to the Dock.  You can reference `coredock.options.effect[#]` to get a human-readable string indicating the effect.

~~~lua
coredock.get_autohide() -> bool
~~~
Returns true or false, indicating whether Dock Hiding is turned on or not.

~~~lua
coredock.get_magnification() -> bool
~~~
Returns true or false, indicating whether Dock Magnification is turned on or not.

~~~lua
coredock.get_magnification_size() -> float
~~~
Returns the Dock magnification size as a number between 0 and 1.

~~~lua
coredock.get_orientation() -> int
~~~
Returns an integer indicating the orientation of the Dock.  You can reference `coredock.options.orientation[#]` to get a human-readable string indicating the orientation.

~~~lua
coredock.get_pinning() -> int
~~~
Returns an integer indicating the pinning of the Dock.  You can reference `coredock.options.pinning[#]` to get a human-readable string indicating the pinning.

~~~lua
coredock.get_tilesize() -> float
~~~
Returns the Dock icon tile size as a number between 0 and 1.

~~~lua
coredock.set_animationeffect(effect)
~~~
Sets the Dock animation effect used when hiding windows. You can reference `coredock.options.effect` to select the appropriate number for the desired effect.

~~~lua
coredock.set_autohide(bool)
~~~
Set Dock Hiding to on (true) or off (false).

~~~lua
coredock.set_magnification(bool)
~~~
Set Dock Magnification to on (true) or off (false).

~~~lua
coredock.set_magnification_size(float)
~~~
Sets the Dock icon magnification size to a number between 0 and 1.

~~~lua
coredock.set_orientation(orientation)
~~~
Sets the Dock orientation to the position indicated by orientation. You can reference `coredock.options.orientation` to select the appropriate number for the desired orientation.

~~~lua
coredock.set_pinning(pinning)
~~~
Sets the Dock pinning to the position indicated by pinning. You can reference `coredock.options.pinning` to select the appropriate number for the desired pinning.

~~~lua
coredock.set_tilesize(float)
~~~
Sets the Dock icon tile size to a number between 0 and 1.

~~~lua
coredock.RestartDock()
~~~
This function restarts the user's Dock instance.  This is not required for any of the functionality of this module, but does come in handy if your dock gets "misplaced" when you change monitor resolution or detach an external monitor (I've seen this occasionally when the Dock is on the left or right.)

### Variables

~~~lua
coredock.options[]
~~~
Connivence array of all currently defined coredock options.

     coredock.options.orientation[]  -- an array of the orientation options available for `set_orientation_and_pinning`
         top         -- put the dock at the top of the monitor
         bottom      -- put the dock at the bottom of the monitor
         left        -- put the dock at the left of the monitor
         right       -- put the dock at the right of the monitor

     coredock.options.pinning[]  -- an array of the pinning options available for `set_orientation_and_pinning`
         start       -- pin the dock at the start of its orientation
         middle      -- pin the dock at the middle of its orientation
         end         -- pin the dock at the end of its orientation

     coredock.options.effect[]   -- an array of the dock animation options for  `set_animationeffect`
         genie       -- use the genie animation
         scale       -- use the scale animation
         suck        -- use the suck animation

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
