mjolnir._asm.pathwatcher
=========================

Watch paths recursively for changes.

This simple example watches your Hydra directory for changes, and when it sees a change, reloads your configs:

    pathwatcher.new(os.getenv("HOME") .. "/.hydra/", hydra.reload):start()

This module is based primarily on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).


### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.pathwatcher
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm.watcher
$ cd mjolnir_asm.watcher/pathwatcher
$ [PREFIX=/usr/local] make install
~~~

### Require

~~~lua
pw = require("mjolnir._asm.pathwatcher")
~~~

### Functions

~~~lua
pw.new(path, fn) -> pathwatcher
~~~
Returns a new pathwatcher that can be started and stopped.  The function registered receives as it's argument, a table containing a list of the files which have changed since it was last invoked.

~~~lua
pw:start()
~~~
Registers pathwatcher's fn as a callback when pathwatcher's path or any descendent changes.

~~~lua
pw:stop()
~~~
Unregisters pathwatcher's fn so it won't be called again until the pathwatcher is restarted.

### Notes

This release is a port of the Hydra pathwatcher code and seems to work as intended, but I do have some issues with it that I'd like to see addressed at some point. At present, it reports on all changes within a directory and all subdirectories with no indication of what has actually changed (added/deleted/changed, etc.) beyond the file name -- I would like to be able to optionally limit this to just the specified directory (no sub-dirs) and include some indicator of the type of change. Maybe even a pattern matcher for just specific files or types of files.  While it is true that some Lua code logic can be used to figure these out, I feel it should be built in to the module.

There is also a situation where if you stop a watcher, and then re-start it without using new again, sometimes (not always) changes that occurred while it was stopped appear immediately... this should be made consistent, one way or the other. Note, however, that stopping and then-restarting a pathwatcher in Hydra seems to crash on my machine, so already this diverges some from the original.

However, it works [mostly] as it did in Hydra, which is this first version's goal.

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
