#import <Cocoa/Cocoa.h>
#import <lauxlib.h>

// require("mjolnir._asm.http_unsafe").send("http://www.asmagill.com","GET",10,{},nil,     function(...) req=table.pack(...) ; print(req[1]) end)

//
// typedef struct _http_t {
//     NSURLConnection*        connection;
//     int                     self;
// } http_t;
//
// static NSMutableIndexSet* httphandlers;
//
// static int store_http(lua_State* L, int idx) {
//     lua_pushvalue(L, idx);
//     int x = luaL_ref(L, LUA_REGISTRYINDEX);
//     [httphandlers addIndex: x];
//     return x;
// }
//
// static void remove_http(lua_State* L, int x) {
//     luaL_unref(L, LUA_REGISTRYINDEX, x);
//     [httphandlers removeIndex: x];
// }
//

// mjolnir._asm.http._send(url, method, timeout, headers, body, fn(code, header, data, err))
// Send an HTTP request using the given method, with the following parameters:
//   url must be a string
//   method must be a string (i.e. "GET")
//   timeout must be a number
//   headers must be a table; may be empty; any keys and values present must both be strings
//   body may be a string or nil
//   fn must be a valid function, and is called with the following parameters:
//     code is a number (is sometimes 0, I think?)
//     header is a table of string->string pairs
//     data is a string on success, nil on failure
//     err is a string on failure, nil on success
static int http_send(lua_State* L) {
    NSURL* url = [NSURL URLWithString:[NSString stringWithUTF8String: luaL_checkstring(L, 1)]];
    NSString* method = [NSString stringWithUTF8String: luaL_checkstring(L, 2)];
    NSTimeInterval timeout = luaL_checknumber(L, 3);
    luaL_checktype(L, 4, LUA_TTABLE);    // headers
    size_t body_n;
    const char* body = lua_tolstring(L, 5, &body_n);
    luaL_checktype(L, 6, LUA_TFUNCTION); // callback

    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeout];
    [req setHTTPMethod:method];

    lua_pushnil(L);
    while (lua_next(L, 4) != 0) {
        NSString* key = [NSString stringWithUTF8String: lua_tostring(L, -2)];
        NSString* val = [NSString stringWithUTF8String: lua_tostring(L, -1)];
        [req addValue:val forHTTPHeaderField:key];
        lua_pop(L, 1);
    }

    if (body) {
        NSData* bodydata = [NSData dataWithBytes:body length:body_n];
        [req setHTTPBody:bodydata];
    }

    lua_pushvalue(L, 6);
    int fn = luaL_ref(L, LUA_REGISTRYINDEX);

    [NSURLConnection
         sendAsynchronousRequest:req
                           queue:[NSOperationQueue mainQueue]
               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                   lua_rawgeti(L, LUA_REGISTRYINDEX, fn);

                   NSHTTPURLResponse* httpresponse = (NSHTTPURLResponse*)response;
                   lua_pushnumber(L, [httpresponse statusCode]);

                   lua_newtable(L);
                   for (NSString* key in [httpresponse allHeaderFields]) {
                       NSString* val = [[httpresponse allHeaderFields] objectForKey:key];
                       lua_pushstring(L, [key UTF8String]);
                       lua_pushstring(L, [val UTF8String]);
                       lua_settable(L, -3);
                   }

                   if (data) {
                       lua_pushlstring(L, [data bytes], [data length]);
                       lua_pushnil(L);
                   }
                   else {
                       lua_pushnil(L);
                       lua_pushstring(L, [[connectionError localizedDescription] UTF8String]);
                   }

                   lua_call(L, 4, 0) ;

                   luaL_unref(L, LUA_REGISTRYINDEX, fn);
               }];

// // build the userdata object
//     http_t* httpreq = lua_newuserdata(L, sizeof(http_t));
//     memset(httpreq, 0, sizeof(http_t));
// // define it's parts
//     httpreq->connection = my_connection ;
// // store registry reference for connection userdata
//     httpreq->self = store_http(L, 1) ;
// // add the metatable
//     luaL_getmetatable(L, "mjolnir._asm.http");
//     lua_setmetatable(L, -2);
//     return 1;
    return 0;
}

// /// mjolnir._asm.http:completed() -> boolean
// /// Method
// /// Returns true or false to indicate if the request has been completed.  True indicates that the request is no longer in the queue and the callback function has been invoked, while false indicates that it is still awaiting a result or timeout.
// static int http_completed(lua_State* L) {
//     http_t* httpreq = luaL_checkudata(L, 1, "mjolnir._asm.http");
// //    lua_settop(L, 1);
//
//     lua_pushboolean(L, [httpreq->connection isFinished]);
//     return 1;
// }

// /// mjolnir._asm.http:cancel() -> self
// /// Method
// /// If the request is still waiting to complete, then this cancels the request.  If the request has been completed, then this method simply returns.  Used for garbage collection to abort incomplete requests during reloads.
// static int http_cancel(lua_State* L) {
//     http_t* httpreq = luaL_checkudata(L, 1, "mjolnir._asm.http");
// //    lua_settop(L, 1);
//
// //    if (![httpreq->connection isFinished]) {
//         [NSURLConnection cancelActuallyAsynchronousRequest:httpreq->connection];
// //    }
//     remove_http(L, httpreq->self);
//     return 0;
// }


static const luaL_Reg http_lib[] = {
    {"_send",       http_send},
//     {"completed",   http_completed},
//     {"cancel",      http_cancel},
//     {"__gc",        http_cancel},
    {NULL, NULL}
};

int luaopen_mjolnir__asm_http_unsafe_internal(lua_State* L) {
    luaL_newlib(L, http_lib);

// http.__index = http
    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");

// put http in registry; necessary for luaL_checkudata()
    lua_pushvalue(L, -1);
    lua_setfield(L, LUA_REGISTRYINDEX, "mjolnir._asm.http");

    return 1;
}
