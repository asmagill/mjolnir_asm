#import <Cocoa/Cocoa.h>
#import <lauxlib.h>

// Common Code

#define USERDATA_TAG    "mjolnir._asm.http"

static int store_udhandler(lua_State* L, NSMutableIndexSet* theHandler, int idx) {
    lua_pushvalue(L, idx);
    int x = luaL_ref(L, LUA_REGISTRYINDEX);
    [theHandler addIndex: x];
    return x;
}

static void remove_udhandler(lua_State* L, NSMutableIndexSet* theHandler, int x) {
    luaL_unref(L, LUA_REGISTRYINDEX, x);
    [theHandler removeIndex: x];
}

static void* push_udhandler(lua_State* L, int x) {
    lua_rawgeti(L, LUA_REGISTRYINDEX, x);
    return lua_touserdata(L, -1);
}

// Not so common code

static NSMutableIndexSet* taskHandlers;

typedef struct _datatask_t {
    NSURLSessionDataTask*   task;
    lua_State*              L;
	BOOL					started;
    BOOL                    completed;
    BOOL                    cancelled;
    int                     fn;
    int                     self;
} datatask_t;

static int http_new(lua_State* L) {
    NSURLSession* moduleURLSession = [NSURLSession sharedSession];
    NSURL* url = [NSURL URLWithString:[NSString stringWithUTF8String: luaL_checkstring(L, 1)]]; // URL
    NSString* method = [NSString stringWithUTF8String: luaL_checkstring(L, 2)];                 // Method
    NSTimeInterval timeout = luaL_checknumber(L, 3);                                            // Timeout
    luaL_checktype(L, 4, LUA_TTABLE);                                                           // Headers
    size_t body_n; const char* body = lua_tolstring(L, 5, &body_n);                             // Body
    luaL_checktype(L, 6, LUA_TFUNCTION);                                                        // Callback
    lua_settop(L, 6);                                                                           // --------

// Build the urlRequest object

    NSMutableURLRequest* urlRequest = [NSMutableURLRequest
                                            requestWithURL:url
                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                           timeoutInterval:timeout];
    [urlRequest setHTTPMethod:method];

    lua_pushnil(L);
    while (lua_next(L, 4) != 0) {
        NSString* key = [NSString stringWithUTF8String: lua_tostring(L, -2)];
        NSString* val = [NSString stringWithUTF8String: lua_tostring(L, -1)];
        [urlRequest addValue:val forHTTPHeaderField:key];
        lua_pop(L, 1);
    }

    if (body) {
        NSData* bodydata = [NSData dataWithBytes:body length:body_n];
        [urlRequest setHTTPBody:bodydata];
    }

    lua_pushvalue(L, 6); int fn = luaL_ref(L, LUA_REGISTRYINDEX);

// build the userdata object

    datatask_t* my_data = lua_newuserdata(L, sizeof(datatask_t));
    memset(my_data, 0, sizeof(datatask_t));
    my_data->L         = L;
    my_data->started   = NO;
    my_data->completed = NO;
    my_data->cancelled = NO;
    my_data->fn        = fn;
    my_data->task      = [moduleURLSession
        dataTaskWithRequest:urlRequest
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
                if (my_data && my_data->task && my_data->self && my_data->fn && my_data->L) {
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

                        remove_udhandler(L, taskHandlers, my_data->self);
                        luaL_unref(L, LUA_REGISTRYINDEX, my_data->fn);
                        my_data->fn = 0 ;
                        my_data->self = 0 ;
                    }
                }
            }
        ];

// store registry reference for connection userdata
    my_data->self = store_udhandler(L, taskHandlers, 1) ;
// add the metatable
    luaL_getmetatable(L, USERDATA_TAG);
    lua_setmetatable(L, -2);

    return 1;
}

/// mjolnir._asm.http:start() -> self
/// Method
/// Begin the URL data request. Returns nil if the task has already been started or cancelled, otherwise returns self.
static int http_start(lua_State* L) {
    datatask_t* my_data = luaL_checkudata(L, 1, USERDATA_TAG);
    lua_settop(L, 1);
	if (my_data->started || my_data->cancelled) {
		lua_pushnil(L) ;
	} else {
		my_data->started = YES;
    	[my_data->task resume];
	}
    return 1;
}

/// mjolnir._asm.http:status() -> started, completed, cancelled
/// Method
/// Returns true or false for each of the flags indicating if the request has been started, if it has been completed, and if it has been cancelled.
static int http_status(lua_State* L) {
    datatask_t* my_data = luaL_checkudata(L, 1, USERDATA_TAG);
    lua_pushboolean(L, my_data->started);
    lua_pushboolean(L, my_data->completed);
    lua_pushboolean(L, my_data->cancelled);
    return 3;
}

/// mjolnir._asm.http:cancel() -> bool
/// Method
/// If the request is still waiting to complete, then this cancels the request.  Returns true if the request was actually cancelled, otherwise false.
static int http_cancel(lua_State* L) {
    datatask_t* my_data = luaL_checkudata(L, 1, USERDATA_TAG);

    if (my_data->started && !(my_data->completed || my_data->cancelled)) {
        my_data->cancelled = YES;
        luaL_unref(L, LUA_REGISTRYINDEX, my_data->fn);
        remove_udhandler(L, taskHandlers, my_data->self);
        my_data->fn = 0 ;
        my_data->self = 0 ;
        my_data->L = NULL ;
        [my_data->task suspend];
    }
	lua_pushboolean(L, my_data->cancelled) ;

    return 1;
}

static int meta_gc(lua_State* L) {
    [taskHandlers release];
    return 0;
}

// Metatable for created objects when _new invoked
static const luaL_Reg http_metalib[] = {
    {"start",   http_start},
    {"status",  http_status},
    {"cancel",  http_cancel},
    {"__gc",    http_cancel},
    {NULL,      NULL}
};

// Functions for returned object when module loads
static const luaL_Reg httpLib[] = {
    {"_new",    http_new},
    {NULL,      NULL}
};

// Metatable for returned object when module loads
static const luaL_Reg meta_gcLib[] = {
    {"__gc",    meta_gc},
    {NULL,      NULL}
};

int luaopen_mjolnir__asm_http2_internal(lua_State* L) {
// Metatable for created objects
    luaL_newlib(L, http_metalib);
        lua_pushvalue(L, -1);
        lua_setfield(L, -2, "__index");
        lua_setfield(L, LUA_REGISTRYINDEX, USERDATA_TAG);

// Create table for luaopen
    luaL_newlib(L, httpLib);
        luaL_newlib(L, meta_gcLib);
        lua_setmetatable(L, -2);

    return 1;
}

// h = require("mjolnir._asm.http2") ; b = h.new("http://www.google.com","GET",10,{},nil,function(...) rb = table.pack(...) ; print("b", rb[1]) end) ; a = h.new("http://10.255.255.1","GET",10,{},nil,function(...) ra = table.pack(...) ; print("a", ra[1]) end) ;
