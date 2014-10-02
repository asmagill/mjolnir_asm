#import <Cocoa/Cocoa.h>
#import <lauxlib.h>

typedef struct _datatask_t {
//    NSURLSession*           session;
    NSURLSessionDataTask*   task;
	BOOL					started;
    BOOL                    completed;
    BOOL                    cancelled;
    int                     fn;
    int                     self;
} datatask_t;

static NSMutableIndexSet* httphandlers;

static int store_http(lua_State* L, int idx) {
    lua_pushvalue(L, idx);
    int x = luaL_ref(L, LUA_REGISTRYINDEX);
    [httphandlers addIndex: x];
    return x;
}

static void remove_http(lua_State* L, int x) {
    luaL_unref(L, LUA_REGISTRYINDEX, x);
    [httphandlers removeIndex: x];
}

// mjolnir._asm.http._new(url, method, timeout, headers, body, fn(code, header, data, err))
// Create an HTTP request using the given method, with the following parameters:
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
static int http_new(lua_State* L) {
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

// build the userdata object
    datatask_t* my_data = lua_newuserdata(L, sizeof(datatask_t));
    memset(my_data, 0, sizeof(datatask_t));
// define it's parts
    my_data->started   = NO;
    my_data->completed = NO;
    my_data->cancelled = NO;
    my_data->fn        = fn;
//     my_data->session   = [NSURLSession sharedSession];
//     my_data->task      = [my_data->session
    my_data->task      = [[NSURLSession sharedSession]
        dataTaskWithRequest:req
          completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
            if ([my_data->task state] == NSURLSessionTaskStateCompleted) {

			// cancelling a request actually invokes this callback immediately, so skip if cancelled.
            if (my_data->started && !(my_data->cancelled || my_data->completed)) {
                lua_rawgeti(L, LUA_REGISTRYINDEX, my_data->fn);

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
                } else {
                	lua_pushnil(L);
                	lua_pushstring(L, [[connectionError localizedDescription] UTF8String]);
                }

                lua_call(L, 4, 0) ;

                my_data->completed = YES;
                luaL_unref(L, LUA_REGISTRYINDEX, fn);
                remove_http(L, my_data->self);
            }}
        }];

// store registry reference for connection userdata
    my_data->self = store_http(L, 1) ;
// add the metatable
    luaL_getmetatable(L, "mjolnir._asm.http");
    lua_setmetatable(L, -2);

    return 1;
//    return 0;
}

/// mjolnir._asm.http:start() -> self
/// Method
/// Begin the URL data request. Returns nil if the task has already been started or cancelled, otherwise returns self.
static int http_start(lua_State* L) {
    datatask_t* my_data = luaL_checkudata(L, 1, "mjolnir._asm.http");

	if (my_data->started || my_data->cancelled) {
		lua_pushnil(L) ;
	} else {
		my_data->started = YES;
		lua_settop(L, 1);
    	[my_data->task resume];
	}
    return 1;
}

/// mjolnir._asm.http:status() -> started, completed, cancelled
/// Method
/// Returns true or false for each of the flags indicating if the request has been started, if it has been completed, and if it has been cancelled.
static int http_status(lua_State* L) {
    datatask_t* my_data = luaL_checkudata(L, 1, "mjolnir._asm.http");

    lua_pushboolean(L, my_data->started);
    lua_pushboolean(L, my_data->completed);
    lua_pushboolean(L, my_data->cancelled);
    return 3;
}

/// mjolnir._asm.http:cancel() -> bool
/// Method
/// If the request is still waiting to complete, then this cancels the request.  Returns true if the request was actually cancelled, otherwise false.
static int http_cancel(lua_State* L) {
    datatask_t* my_data = luaL_checkudata(L, 1, "mjolnir._asm.http");

    if (my_data->started && !(my_data->completed || my_data->cancelled)) {
        my_data->cancelled = YES;
        [my_data->task cancel];
    }
	lua_pushboolean(L, my_data->cancelled) ;
    return 1;
}

static const luaL_Reg http_lib[] = {
    {"_new",                http_new},
    {"start",               http_start},
    {"status",              http_status},
    {"cancel",              http_cancel},
    {"__gc",                http_cancel},
    {NULL, NULL}
};

int luaopen_mjolnir__asm_http_internal(lua_State* L) {
    luaL_newlib(L, http_lib);

// http.__index = http
    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");

// put http in registry; necessary for luaL_checkudata()
    lua_pushvalue(L, -1);
    lua_setfield(L, LUA_REGISTRYINDEX, "mjolnir._asm.http");

    return 1;
}

// h = require("mjolnir._asm.http") ; b = h.new("http://www.google.com","GET",10,{},nil,function(...) rb = table.pack(...) ; print("b", rb[1]) end) ; a = h.new("http://10.255.255.1","GET",10,{},nil,function(...) ra = table.pack(...) ; print("a", ra[1]) end) ;
