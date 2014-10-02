mjolnir._asm.http
=================

For making HTTP/HTTPS requests

This module utilizes NSURLSession, which was introduced with OS X 10.9.

This module utilizes code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).

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
http.new(url, method, timeout, headers, body, fn(code, header, data, err)) -> task
~~~
Create an HTTP request using the given method, with the following parameters:

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
http:start() -> self
~~~
Begin the URL data request. Returns nil if the task has already been started or cancelled, otherwise returns self.

~~~lua
http.send(url, method, timeout, headers, body, fn(code, header, data, err)) -> task
~~~
Shorthand for mjolnir._asm.http.send(...):start()

~~~lua
http:status() -> started, completed, cancelled
~~~
Returns true or false for each of the flags indicating if the request has been started, if it has been completed, and if it has been cancelled.

~~~lua
http:cancel() -> bool
~~~
If the request is still waiting to complete or hasn't been started, then this cancels the request.  Returns true if the request was actually cancelled, or false if the task was already completed.

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
