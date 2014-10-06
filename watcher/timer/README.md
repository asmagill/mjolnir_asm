mjolnir._asm.timer
==================

Execute functions with various timing rules.

This module is based on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.timer
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm.watcher
$ cd mjolnir_asm.watcher/timer
$ [PREFIX=/usr/local] make install
~~~

### Require

~~~lua
timer = require("mjolnir._asm.timer")
~~~

### Functions

~~~lua
timer.seconds(n) -> sec
~~~
Returns the number of seconds in seconds.

~~~lua
timer.minutes(n) -> sec
~~~
Returns the number of minutes in seconds.

~~~lua
timer.hours(n) -> sec
~~~
Returns the number of hours in seconds.

~~~lua
timer.days(n) -> sec
~~~
Returns the number of days in seconds.

~~~lua
timer.weeks(n) -> sec
~~~
Returns the number of weeks in seconds.

~~~lua
timer.doafter(sec, fn)
~~~
Runs the function after sec seconds.

~~~lua
timer.new(interval, fn) -> timer
~~~
Creates a new timer that can be started; interval is specified in seconds as a decimal number.

~~~lua
timer:start() -> self
~~~
Begins to execute timer.fn every N seconds, as defined when the timer was created; calling this does not cause an initial firing of the timer immediately.

~~~lua
timer:stop() -> self
~~~
Stops the timer's fn from getting called until started again.


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
