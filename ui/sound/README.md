mjolnir._asm.ui.sound
==========================

Mjolnir access to NSSound via lua.

### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.ui.sound
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm.ui
$ cd mjolnir_asm.ui/sound
$ [PREFIX=/usr/local] make install
~~~

### Require

~~~lua
sound = require("mjolnir._asm.ui.sound")
~~~

### Functions
~~~lua
sound.get_byname(string) -> sound
~~~
Attempts to locate and load a named sound.  By default, the only named sounds are the System Sounds (found in ~/Library/Sounds, /Library/Sounds, /Network/Library/Sounds, and /System/Library/Sounds. You can also name sounds you've previously loaded with this module and this name will persist as long as Mjolnir is running.  If the name specified cannot be found, this function returns `nil`.

~~~lua
sound.get_byfile(string) -> sound
~~~
Attempts to locate and load the sound file at the location specified and return an NSSound object for the sound file.  Returns `nil` if it is unable to load the file.

~~~lua
sound.soundTypes() -> array
~~~
Returns an array of the UTI formats supported by this module for sound playback.

~~~lua
sound.soundFileTypes() -> array
~~~
Returns an array of the file extensions for file types supported by this module for sound playback.  Note that this uses a method which has been deprecated since 10.5, so while it apparently sticks around, it may be removed in the future. The preferred method is to use the UTI values returned via `mjolnir._asm.ui.sound.soundTypes` for determination.

##### Control Methods
~~~lua
sound:play() -> bool
~~~
Attempts to play the loaded sound and return control to Mjolnir.  Returns true or false indicating success or failure.

~~~lua
sound:pause() -> bool
~~~
Attempts to pause the loaded sound.  Returns true or false indicating success or failure.

~~~lua
sound:resume() -> bool
~~~
Attempts to resume a paused sound.  Returns true or false indicating success or failure.

~~~lua
sound:stop() -> bool
~~~
Attempts to stop a playing sound.  Returns true or false indicating success or failure.

##### Attribute Methods
~~~lua
sound:loopSound([bool]) -> bool
~~~
If a boolean argument is provided it is used to set whether the sound will loop upon completion.  Returns the current status of this attribute.  Note that if a sound is looped, it will not call the callback function (if defined) upon completion of playback.

~~~lua
sound:stopOnRelease([bool]) -> bool
~~~
If a boolean argument is provided it is used to set whether the sound will be stopped when released (when Mjolnir is reloaded or `release` is called).  Returns the current status of this attribute.  Defaults to `true`.  This can only be changed if you've assigned a name to the sound; otherwise, it becomes possible to have a sound you can't access running in the background.

~~~lua
sound:name([string]) -> string
~~~
If a string argument is provided it is used to set name the sound. Returns the current name, if defined.  This name can be used to reselect a sound with `get_byname` as long as Mjolnir has not been exited since the sound was named.  Returns `nil` if no name has been assigned.

~~~lua
sound:device([string]) -> string
~~~
If a string argument is provided it is used to set name the playback device for the sound. Returns the current name, if defined or nil if it hasn't been changed from the System default.  Note that this name is not the same as the name returned by the `name` method of `mjolnir._asm.sys.audiodevice`.  Make sure you're using version 0.2-1 or later of `mjolnir._asm.sys.audiodevice` and use the `uid` method to get the proper device names for this method.  Setting this to `nil` will use the system default device.

~~~lua
sound:currentTime([seconds]) -> seconds
~~~
If a number argument is provided it is used to set the playback location to the number of seconds specified.  Returns the current position in seconds.

~~~lua
sound:duration() -> seconds
~~~
Returns the duration of the sound in seconds.

~~~lua
sound:volume([number]) -> number
~~~
If a number argument is provided it is used to set the playback volume relative to the system volume.  Returns the current playback volume relative to the current system volume.  The number will be between 0.0 and 1.0.

~~~lua
sound:callback([fn|nil]) -> bool
~~~
If no argument is provided, returns whether or not the sound has an assigned callback function to invoke when the sound playback has completed.  If you provide a function as the argument, this function will be invoked when playback completes with an argument indicating whether playback ended normally (at the end of the song, for example) or if ended abnormally (stopped via the `stop` method).  If `nil` is provided, then any existing callback function will be removed.  This is called with `nil` during garbage collection (during a reload of Mjolnir) to prevent invoking a callback that no longer exists if playback isn't stopped at reload.

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
