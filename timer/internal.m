#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import <lauxlib.h>

static NSMutableIndexSet* handlers;

static int store_timer(lua_State* L, int idx) {
    lua_pushvalue(L, idx);
    int x = luaL_ref(L, LUA_REGISTRYINDEX);
    [handlers addIndex: x];
    return x;
}

static void remove_timer(lua_State* L, int x) {
    luaL_unref(L, LUA_REGISTRYINDEX, x);
    [handlers removeIndex: x];
}

typedef struct _timer_t {
    lua_State* L;
    CFRunLoopTimerRef t;
    int fn;
    int self;
    BOOL started;
} timer_t;

static void callback(CFRunLoopTimerRef timer, void *info) {
    timer_t* t = info;
    lua_State* L = t->L;
    lua_rawgeti(L, LUA_REGISTRYINDEX, t->fn);
    lua_call(L, 0, 0);
}

// mjolnir._asm.timer._doafter(sec, fn())
// Function
// Runs the function after sec seconds.
// static int timer_doafter(lua_State* L) {
//     double delayInSeconds = luaL_checknumber(L, 1);
//     luaL_checktype(L, 2, LUA_TFUNCTION);
//     int closureref = luaL_ref(L, LUA_REGISTRYINDEX);
//
//     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//         lua_rawgeti(L, LUA_REGISTRYINDEX, closureref);
//         lua_call(L, 0, 0);
//         luaL_unref(L, LUA_REGISTRYINDEX, closureref);
//     });
//
//     return 0;
// }

// mjolnir._asm.timer._new(interval, fn) -> timer
// Function
// Creates a new timer that can be started; interval is specified in seconds as a decimal number.
static int timer_new(lua_State* L) {
    NSTimeInterval sec = luaL_checknumber(L, 1);
    luaL_checktype(L, 2, LUA_TFUNCTION);

    timer_t* timer = lua_newuserdata(L, sizeof(timer_t));
    memset(timer, 0, sizeof(timer_t));
    timer->L = L;

    lua_pushvalue(L, 2);
    timer->fn = luaL_ref(L, LUA_REGISTRYINDEX);

    luaL_getmetatable(L, "mjolnir._asm.timer");
    lua_setmetatable(L, -2);

    CFRunLoopTimerContext ctx = {0};
    ctx.info = timer;
    timer->t = CFRunLoopTimerCreate(NULL, 0, sec, 0, 0, callback, &ctx);

    return 1;
}

/// mjolnir._asm.timer:start() -> self
/// Method
/// Begins to execute mjolnir._asm.timer.fn every N seconds, as defined when the timer was created; calling this does not cause an initial firing of the timer immediately.
static int timer_start(lua_State* L) {
    timer_t* timer = luaL_checkudata(L, 1, "mjolnir._asm.timer");
    lua_settop(L, 1);

    if (timer->started) return 1;
    timer->started = YES;

    timer->self = store_timer(L, 1);
    CFRunLoopTimerSetNextFireDate(timer->t, CFAbsoluteTimeGetCurrent() + CFRunLoopTimerGetInterval(timer->t));
    CFRunLoopAddTimer(CFRunLoopGetMain(), timer->t, kCFRunLoopCommonModes);
    return 1;
}

// mjolnir._asm.timer._doafter(sec, fn())
// Function
// Runs the function after sec seconds.
static int timer_doafter(lua_State* L) {
    NSTimeInterval sec = luaL_checknumber(L, 1);
    luaL_checktype(L, 2, LUA_TFUNCTION);

    timer_t* timer = lua_newuserdata(L, sizeof(timer_t));
    memset(timer, 0, sizeof(timer_t));
    timer->L = L;

    lua_pushvalue(L, 2);
    timer->fn = luaL_ref(L, LUA_REGISTRYINDEX);

    luaL_getmetatable(L, "mjolnir._asm.timer");
    lua_setmetatable(L, -2);

    CFRunLoopTimerContext ctx = {0};
    ctx.info = timer;
    timer->t = CFRunLoopTimerCreate(NULL, 0, 0, 0, 0, callback, &ctx);
    timer->started = YES;
    timer->self = store_timer(L, 1);

    CFRunLoopTimerSetNextFireDate(timer->t, CFAbsoluteTimeGetCurrent() + sec);
    CFRunLoopAddTimer(CFRunLoopGetMain(), timer->t, kCFRunLoopCommonModes);
    return 1;
}

/// mjolnir._asm.timer:stop() -> self
/// Method
/// Stops the timer's fn from getting called until started again.
static int timer_stop(lua_State* L) {
    timer_t* timer = luaL_checkudata(L, 1, "mjolnir._asm.timer");
    lua_settop(L, 1);

    if (!timer->started) return 1;
    timer->started = NO;

    remove_timer(L, timer->self);
    CFRunLoopRemoveTimer(CFRunLoopGetMain(), timer->t, kCFRunLoopCommonModes);
    return 1;
}

static int timer_gc(lua_State* L) {
    timer_t* timer = luaL_checkudata(L, 1, "mjolnir._asm.timer");
    luaL_unref(L, LUA_REGISTRYINDEX, timer->fn);
    CFRunLoopTimerInvalidate(timer->t);
    CFRelease(timer->t);
    return 0;
}

static const luaL_Reg timerlib[] = {
    // class methods
    {"_doafter", timer_doafter},
    {"_new", timer_new},

    // instance methods
    {"start", timer_start},
    {"stop", timer_stop},

    // metamethods
    {"__gc", timer_gc},

    {NULL, NULL}
};

int luaopen_mjolnir__asm_timer_internal(lua_State* L) {
    luaL_newlib(L, timerlib);

    // timer.__index = timer
    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");

    // put timer in registry; necessary for luaL_checkudata()
    lua_pushvalue(L, -1);
    lua_setfield(L, LUA_REGISTRYINDEX, "mjolnir._asm.timer");

    return 1;
}
