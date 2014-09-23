mjolnir_asm
===========

Development space  for Mjolnir modules under mjolnir._asm

Published modules are listed as *Currently Available*.  Follow their link for the code making up the deployed version.  This repository may contain updates which have not yet been published or *Work In Progress*.

### Currently available:

|Module                                                                                | Method   | Version | Description                                          |
|:-------------------------------------------------------------------------------------|:---------|:-------:|:-----------------------------------------------------|
|[mjolnir._asm.applistener](https://github.com/asmagill/mjolnir_asm.applistener)       | Luarocks | 0.1-1   | Hydra's notify.applistener module.                   |
|[mjolnir._asm.compat_51](https://github.com/asmagill/mjolnir_asm.compat_51)           | Luarocks | 0.3-1   | Missing Lua 5.1 compatibility functions for Mjolnir  |
|[mjolnir._asm.data](https://github.com/asmagill/mjolnir_asm.data)                     | Luarocks | 0.1-1   | Hydra's json, pasteboard, utf8, uuid functions       |
|[mjolnir._asm.eventtap](https://github.com/asmagill/mjolnir_asm.eventtap)             | Luarocks | 0.1-1   | Hydra's eventtap module                              |
|[mjolnir._asm.eventtap.event](https://github.com/asmagill/mjolnir_asm.eventtap.event) | Luarocks | 0.1-1   | Hydra's eventtap.event module                        |
|[mjolnir._asm.ipc](https://github.com/asmagill/mjolnir_asm.ipc)                       | Luarocks | 0.1-1   | Hydra's IPC and Command Line application for Mjolnir |
|[mjolnir._asm.modal_hotkey](https://github.com/asmagill/mjolnir_asm.modal_hotkey)     | Luarocks | 0.1-1   | Hydra's modal hotkeys for Mjolnir                    |
|[mjolnir._asm.modules](https://github.com/asmagill/mjolnir_asm.modules)               | Luarocks | 0.3-2   | Module version and update tracking for Mjolnir       |
|[mjolnir._asm.notify](https://github.com/asmagill/mjolnir_asm.notify)                 | Luarocks | 0.3-1   | Hydra's notify function in Mjolnir                   |
|[mjolnir._asm.pathwatcher](https://github.com/asmagill/mjolnir_asm.pathwatcher)       | Luarocks | 0.1-1   | Hydra's pathwatcher module                           |
|[mjolnir._asm.settings](https://github.com/asmagill/mjolnir_asm.settings)             | Luarocks | 0.1-1   | Hydra's Get and Set for persistent data in Mjolnir   |
|[mjolnir._asm.timer](https://github.com/asmagill/mjolnir_asm.timer)                   | Luarocks | 0.1-1   | Hydra's timer module for Mjolnir                     |
|[mjolnir._asm.utf8_53](https://github.com/asmagill/mjolnir_asm.utf8_53)               | Luarocks | 0.1-1   | Lua 5.3's planned UTF8 library wrapped for Mjolnir.  |

### Work In progress:

|Module                                                                                | Version | Description                                                                    |
|:-------------------------------------------------------------------------------------|:-------:|:-------------------------------------------------------------------------------|
|[mjolnir._asm.script](https://github.com/asmagill/mjolnir_asm.script)                 | 0.1-1   | Hydra's Applescript module, + some shell stuff, planned.                       |
|[mjolnir._asm.hydra](https://github.com/asmagill/mjolnir_asm.hydra)                   | 0.1-1   | A collection, and provider of some of the individual functions from Hydra.     |
|[mjolnir._asm.undocumented](https://github.com/asmagill/mjolnir_asm.undocumented)     |         | A collection, like this, of modules known to use private or undocumented APIs. |

Also, see README.md in each modules directory.

The Hydra collection contains submodules which share the same repository as the main module in an effort to clean up my repo list and start joining related modules. Some of the above modules may eventually be deprecated and moved into this collection, or into another one.  To the best of my ability, I will attempt to do this with minimal to no changes in their naming within Luarocks, unless it is a significant departure or change from the original intent of the module.

**NOTE: README's for in progress modules may mention luarocks, but probably haven't been uploaded yet, unless it's a major change or rewrite of an existing, older module.**

### License

> Released under MIT license.
>
> Copyright (c) 2014 Aaron Magill
>
> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
>
