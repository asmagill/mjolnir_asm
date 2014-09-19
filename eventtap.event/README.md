mjolnir._asm.eventtap.event
===========================

Functionality to inspect, modify, and create events for [mjolnir_asm.eventtap](https://github.com/asmagill/mjolnir_asm.eventtap) is provided by this module.

This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

### Luarocks Install
This module is not available via luarocks yet... clone the repository (or download the zip file), enter the created directory and do the following:

~~~bash
$ luarocks [--tree=mjolnir] make
~~~

### Require

~~~lua
eventtap = require("mjolnir._asm.event")
~~~
This will automatically include this module at `eventtap.event`

### Functions

~~~lua
eventtap.event:getflags() -> table
~~~
Returns a table with any of the strings {"cmd", "alt", "shift", "ctrl", "fn"} as keys pointing to the value `true`

~~~lua
eventtap.event:setflags(table)
~~~
The table may have any of the strings {"cmd", "alt", "shift", "ctrl", "fn"} as keys pointing to the value `true`

~~~lua
eventtap.event:getkeycode() -> keycode
~~~
Gets the keycode for the given event; only applicable for key-related events. The keycode is a numeric value from the `mjolnir.keycodes.map` table.

~~~lua
eventtap.event:setkeycode(keycode)
~~~
Sets the keycode for the given event; only applicable for key-related events. The keycode is a numeric value from the `mjolnir.keycodes.map` table.

~~~lua
eventtap.event:post(app = nil)
~~~
Posts the event to the system as if the user did it manually. If app is a valid application instance, posts this event only to that application (I think).

~~~lua
eventtap.event:gettype() -> number
~~~
Gets the type of the given event; return value will be one of the values in the eventtap.event.types table.

~~~lua
eventtap.event:getproperty(prop) -> number
~~~
Gets the given property of the given event; prop is one of the values in the mjolnir._asm.eventtap.event.properties table; return value is a number defined here: https://developer.apple.com/library/mac/documentation/Carbon/Reference/QuartzEventServicesRef/Reference/reference.html#//apple_ref/c/tdef/CGEventField

~~~lua
eventtap.event:setproperty(prop, value)
~~~
Sets the given property of the given event; prop is one of the values in the mjolnir._asm.eventtap.event.properties table; value is a number defined here: https://developer.apple.com/library/mac/documentation/Carbon/Reference/QuartzEventServicesRef/Reference/reference.html#//apple_ref/c/tdef/CGEventField

~~~lua
eventtap.event.newkeyevent(mods, key, isdown) -> event
~~~
Creates a keyboard event.
  - mods is a table with any of: {'ctrl', 'alt', 'cmd', 'shift', 'fn'}
  - key has the same meaning as in the `hotkey` module
  - isdown is a boolean, representing whether the key event would be a press or release

~~~lua
eventtap.event.newmouseevent(type, point, button) -> event
~~~
Creates a new mouse event.
  - type is one of the values in eventtap.event.types
  - point is a table with keys {x,y}
  - button is a string of one of the values: {'left', 'right', 'middle'}

### Variables

~~~lua
eventtap.event.types[]
~~~
Table for use with `mjolnir._asm.eventtap.new`, with the following keys (and their reverse, for decoding purposes):

    keydown, keyup,
    leftmousedown, leftmouseup, leftmousedragged,
    rightmousedown, rightmouseup, rightmousedragged,
    middlemousedown, middlemouseup, middlemousedragged,
    mousemoved, flagschanged, scrollwheel

~~~lua
eventtap.event.properties[]
~~~
For use with mjolnir._asm.eventtap.event:{get,set}property; contains the following keys (and their reverse, for decoding purposes):

     - MouseEventNumber
     - MouseEventClickState
     - MouseEventPressure
     - MouseEventButtonNumber
     - MouseEventDeltaX
     - MouseEventDeltaY
     - MouseEventInstantMouser
     - MouseEventSubtype
     - KeyboardEventAutorepeat
     - KeyboardEventKeycode
     - KeyboardEventKeyboardType
     - ScrollWheelEventDeltaAxis1
     - ScrollWheelEventDeltaAxis2
     - ScrollWheelEventDeltaAxis3
     - ScrollWheelEventFixedPtDeltaAxis1
     - ScrollWheelEventFixedPtDeltaAxis2
     - ScrollWheelEventFixedPtDeltaAxis3
     - ScrollWheelEventPointDeltaAxis1
     - ScrollWheelEventPointDeltaAxis2
     - ScrollWheelEventPointDeltaAxis3
     - ScrollWheelEventInstantMouser
     - TabletEventPointX
     - TabletEventPointY
     - TabletEventPointZ
     - TabletEventPointButtons
     - TabletEventPointPressure
     - TabletEventTiltX
     - TabletEventTiltY
     - TabletEventRotation
     - TabletEventTangentialPressure
     - TabletEventDeviceID
     - TabletEventVendor1
     - TabletEventVendor2
     - TabletEventVendor3
     - TabletProximityEventVendorID
     - TabletProximityEventTabletID
     - TabletProximityEventPointerID
     - TabletProximityEventDeviceID
     - TabletProximityEventSystemTabletID
     - TabletProximityEventVendorPointerType
     - TabletProximityEventVendorPointerSerialNumber
     - TabletProximityEventVendorUniqueID
     - TabletProximityEventCapabilityMask
     - TabletProximityEventPointerType
     - TabletProximityEventEnterProximity
     - EventTargetProcessSerialNumber
     - EventTargetUnixProcessID
     - EventSourceUnixProcessID
     - EventSourceUserData
     - EventSourceUserID
     - EventSourceGroupID
     - EventSourceStateID
     - ScrollWheelEventIsContinuous

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
