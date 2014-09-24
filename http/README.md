mjolnir._asm.http
=================

For making HTTP/HTTPS requests

This module is based on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

### Luarocks Install
~~~bash
$ luarocks [--tree=mjolnir] install mjolnir._asm.http
~~~

### Local Install
~~~bash
$ git clone https://github.com/asmagill/mjolnir_asm.http
$ cd mjolnir_asm.http
$ [PREFIX=/usr/local] make install
~~~

### Require

~~~lua
http = require("mjolnir._asm.http")
~~~

### Functions

~~~lua
http.send(url, method, timeout, headers, body, fn(code, header, data, err)) -> http
~~~
Send an HTTP request using the given method, with the following parameters:
    url must be a string
    method must be a string (i.e. "GET")
    timeout must be a number
    headers must be a table; may be empty; any keys and values present must both be strings
    body may be a string or nil
    fn must be a valid function, and is called with the following parameters:
    code is a number (is sometimes 0, I think?)
    header is a table of string->string pairs
    data is a string on success, nil on failure
    err is a string on failure, nil on success

~~~lua
http:completed() -> boolean
~~~
Returns true or false to indicate if the request has been completed.  True indicates that the request is no longer in the queue and the callback function has been invoked, while false indicates that it is still awaiting a result or timeout.

~~~lua
http:cancel() -> self
~~~
If the request is still waiting to complete, then this cancels the request.  If the request has been completed, then this method simply returns.  Used for garbage collection to abort incomplete requests during reloads.

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
