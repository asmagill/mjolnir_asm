#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import <lauxlib.h>

#import <IOKit/ps/IOPowerSources.h>
#import <IOKit/ps/IOPSKeys.h>

// Common Code

#define USERDATA_TAG    "mjolnir._asm.watcher.battery"

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

static NSMutableIndexSet* batteryHandlers;

typedef struct _battery_watcher_t {
    lua_State* L;
    CFRunLoopSourceRef t;
    int fn;
    int self;
    bool started;
} battery_watcher_t;

static void callback(void *info) {
    battery_watcher_t* t = info;
    lua_State* L = t->L;
    lua_rawgeti(L, LUA_REGISTRYINDEX, t->fn);
    lua_call(L, 0, 0);
}

// mjolnir._asm.watcher.battery.new(fn) -> watcher
// Function
// Creates a battery watcher that can be started. When started, fn will be called each time a battery attribute changes.
static int battery_watcher_new(lua_State* L) {
    luaL_checktype(L, 1, LUA_TFUNCTION);

    battery_watcher_t* watcher = lua_newuserdata(L, sizeof(battery_watcher_t));
    watcher->L = L;

    lua_pushvalue(L, 1);
    watcher->fn = luaL_ref(L, LUA_REGISTRYINDEX);

    luaL_getmetatable(L, USERDATA_TAG);
    lua_setmetatable(L, -2);

    watcher->t = IOPSNotificationCreateRunLoopSource(callback, watcher);
    watcher->started = false;
    return 1;
}

/// mjolnir._asm.watcher.battery:start() -> self
/// Method
/// Starts the battery watcher, making it so fn is called each time a battery attribute changes.
static int battery_watcher_start(lua_State* L) {
    battery_watcher_t* watcher = luaL_checkudata(L, 1, USERDATA_TAG);

    lua_settop(L, 1);

    if (watcher->started) return 1;

    watcher->started = YES;

    watcher->self = store_udhandler(L, batteryHandlers, 1);
    CFRunLoopAddSource(CFRunLoopGetMain(), watcher->t, kCFRunLoopCommonModes);
    return 1;
}

/// mjolnir._asm.watcher.battery:stop() -> self
/// Function
/// Stops the battery watcher's fn from getting called until started again.
static int battery_watcher_stop(lua_State* L) {
    battery_watcher_t* watcher = luaL_checkudata(L, 1, USERDATA_TAG);
    lua_settop(L, 1);

    if (!watcher->started) return 1;

    watcher->started = NO;
    remove_udhandler(L, batteryHandlers, watcher->self);
    CFRunLoopRemoveSource(CFRunLoopGetMain(), watcher->t, kCFRunLoopCommonModes);
    return 1;
}

static int battery_watcher_gc(lua_State* L) {
    battery_watcher_t* watcher = luaL_checkudata(L, 1, USERDATA_TAG);

    lua_pushcfunction(L, battery_watcher_stop) ; lua_pushvalue(L,1); lua_call(L, 1, 1);

    luaL_unref(L, LUA_REGISTRYINDEX, watcher->fn);
    CFRunLoopSourceInvalidate(watcher->t);
    CFRelease(watcher->t);
    return 0;
}

static int meta_gc(lua_State* L) {
    [batteryHandlers release];
    return 0;
}

// Metatable for created objects when _new invoked
static const luaL_Reg battery_metalib[] = {
    {"start",   battery_watcher_start},
    {"stop",    battery_watcher_stop},
    {"__gc",    battery_watcher_gc},
    {NULL,      NULL}
};

// Functions for returned object when module loads
static const luaL_Reg batteryLib[] = {
    {"_new",    battery_watcher_new},
    {NULL,      NULL}
};

// Metatable for returned object when module loads
static const luaL_Reg meta_gcLib[] = {
    {"__gc",    meta_gc},
    {NULL,      NULL}
};

int luaopen_mjolnir__asm_watcher_battery_internal(lua_State* L) {
// Metatable for created objects
    luaL_newlib(L, battery_metalib);
        lua_pushvalue(L, -1);
        lua_setfield(L, -2, "__index");
        lua_setfield(L, LUA_REGISTRYINDEX, USERDATA_TAG);

// Create table for luaopen
    luaL_newlib(L, batteryLib);
        luaL_newlib(L, meta_gcLib);
        lua_setmetatable(L, -2);

    return 1;
}
