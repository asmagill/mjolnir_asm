mjolnir._asm.sys.battery
========================

Functions for getting battery info. All functions here may return nil, if the information requested is not available.

This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.sys.battery
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm.sys
$ cd mjolnir_asm.sys/battery
$ [PREFIX=/usr/local] make install
~~~

### Require
~~~lua
battery = require("mjolnir._asm.sys.battery")
~~~

### Functions
~~~lua
battery.get_all() -> table
~~~
Returns a table containing the keyed results of all of the following.  Useful if you want more than one piece of information at a given time.

~~~lua
battery.cycles() -> number
~~~
Returns the number of cycles the connected battery has went through.

~~~lua
battery.name() -> string
~~~
Returns the name of the battery.

~~~lua
battery.maxcapacity() -> number
~~~
Returns the current maximum capacity of the battery in mAh.

~~~lua
battery.capacity() -> number
~~~
Returns the current capacity of the battery in mAh.

~~~lua
battery.designcapacity() -> number
~~~
Returns the design capacity of the battery in mAh.

~~~lua
battery.voltage() -> number
~~~
Returns the voltage flow of the battery in mV.

~~~lua
battery.amperage() -> number
~~~
Returns the amperage of the battery in mA. (will be negative if battery is discharging)

~~~lua
battery.watts() -> number
~~~
Returns the watts into or out of the battery in Watt (will be negative if battery is discharging)

~~~lua
battery.health() -> string
~~~
Returns the health status of the battery. One of {Good, Fair, Poor}  [^1]

~~~lua
battery.healthcondition() -> string
~~~
Returns the health condition status of the battery. One of {Check Battery, Permanent Battery Failure}. Nil if there is no health condition set.  [^1]

~~~lua
battery.percentage() -> number
~~~
Returns the current percentage of the battery between 0 and 100.

~~~lua
battery.timeremaining() -> number
~~~
Returns the time remaining in minutes. Or a negative value: -1 = calculating time remaining, -2 = unlimited (i.e. you're charging, or apple has somehow discovered an infinite power source.)

~~~lua
battery.timetofullcharge() -> number
~~~
Returns the time remaining to a full charge in minutes. Or a negative value, -1 = calculating time remaining.

~~~lua
battery.ischarging() -> boolean
~~~
Returns true if the battery is charging.

~~~lua
battery.ischarged() -> boolean
~~~
Returns true if battery is charged.

~~~lua
battery.isfinishingcharge() -> boolean
~~~
Returns true if battery is finishing charge.

~~~lua
battery.powersource() -> string
~~~
Returns current source of power. One of {AC Power, Battery Power, Off Line}.

------------------

[^1]: Exact text may differ depending upon battery manufacturer and date.  These are the current Apple recommendations to manufacturers.

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
