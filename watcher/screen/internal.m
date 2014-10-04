#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import <lauxlib.h>


// Common Code

#define USERDATA_TAG    "mjolnir._asm.watcher.screen"

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

static NSMutableIndexSet* screenHandlers;

@interface MJScreenWatcher : NSObject
@property lua_State* L;
@property int fn;
@end

@implementation MJScreenWatcher
- (void) screensChanged:(id)bla {
    lua_State* L = self.L;
    lua_rawgeti(L, LUA_REGISTRYINDEX, self.fn);
    lua_call(L, 0, 0);
}
@end


typedef struct _screenwatcher_t {
    bool running;
    int fn;
    int registryHandle;
    void* obj;
} screenwatcher_t;

// mjolnir._asm.watcher.screen.new(fn) -> watcher
// Function
// Creates a new screen-watcher that can be started; fn will be called when your screen layout changes in any way, whether by adding/removing/moving monitors or like whatever.
static int screen_watcher_new(lua_State* L) {
    luaL_checktype(L, 1, LUA_TFUNCTION);

    screenwatcher_t* screenwatcher = lua_newuserdata(L, sizeof(screenwatcher_t));
    memset(screenwatcher, 0, sizeof(screenwatcher_t));

    lua_pushvalue(L, 1);
    screenwatcher->fn = luaL_ref(L, LUA_REGISTRYINDEX);

    MJScreenWatcher* object = [[MJScreenWatcher alloc] init];
    object.L = L;
    object.fn = screenwatcher->fn;
    screenwatcher->obj = (__bridge_retained void*)object;
    screenwatcher->running = NO;
    screenwatcher->registryHandle = store_udhandler(L, screenHandlers, 1);

    luaL_getmetatable(L, USERDATA_TAG);
    lua_setmetatable(L, -2);

    return 1;
}

/// mjolnir._asm.watcher.screen:start() -> watcher
/// Function
/// Starts the screen watcher, making it so fn is called each time the screen arrangement changes.
static int screen_watcher_start(lua_State* L) {
    screenwatcher_t* screenwatcher = luaL_checkudata(L, 1, USERDATA_TAG);
    lua_settop(L,1) ;

    if (screenwatcher->running) return 1;
    screenwatcher->running = YES;

    [[NSNotificationCenter defaultCenter] addObserver:(__bridge id)screenwatcher->obj
                                             selector:@selector(screensChanged:)
                                                 name:NSApplicationDidChangeScreenParametersNotification
                                               object:nil];

    return 1;
}

/// mjolnir._asm.watcher.screen:stop() -> watcher
/// Function
/// Stops the screen watcher's fn from getting called until started again.
static int screen_watcher_stop(lua_State* L) {
    screenwatcher_t* screenwatcher = luaL_checkudata(L, 1, USERDATA_TAG);
    lua_settop(L,1) ;

    if (!screenwatcher->running) return 1;
    screenwatcher->running = NO;

    remove_udhandler(L, screenHandlers, screenwatcher->registryHandle);
    [[NSNotificationCenter defaultCenter] removeObserver:(__bridge id)screenwatcher->obj];

    return 1;
}

static int screen_watcher_gc(lua_State* L) {
    screenwatcher_t* screenwatcher = luaL_checkudata(L, 1, USERDATA_TAG);

    lua_pushcfunction(L, screen_watcher_stop) ; lua_pushvalue(L,1); lua_call(L, 1, 1);

    luaL_unref(L, LUA_REGISTRYINDEX, screenwatcher->fn);

    MJScreenWatcher* object = (__bridge_transfer id)screenwatcher->obj;
    object = nil;

    return 0;
}

static int meta_gc(lua_State* L) {
    [screenHandlers release];
    return 0;
}

// Metatable for created objects when _new invoked
static const luaL_Reg screen_metalib[] = {
    {"start",   screen_watcher_start},
    {"stop",    screen_watcher_stop},
    {"__gc",    screen_watcher_gc},
    {NULL,      NULL}
};

// Functions for returned object when module loads
static const luaL_Reg screenLib[] = {
    {"_new",     screen_watcher_new},
    {NULL,      NULL}
};

// Metatable for returned object when module loads
static const luaL_Reg meta_gcLib[] = {
    {"__gc",    meta_gc},
    {NULL,      NULL}
};

int luaopen_mjolnir__asm_watcher_screen_internal(lua_State* L) {
// Metatable for created objects
    luaL_newlib(L, screen_metalib);
        lua_pushvalue(L, -1);
        lua_setfield(L, -2, "__index");
        lua_setfield(L, LUA_REGISTRYINDEX, USERDATA_TAG);

// Create table for luaopen
    luaL_newlib(L, screenLib);
        luaL_newlib(L, meta_gcLib);
        lua_setmetatable(L, -2);

    return 1;
}
