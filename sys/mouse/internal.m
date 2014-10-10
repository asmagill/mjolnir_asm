#import <Cocoa/Cocoa.h>
#import <lauxlib.h>

static NSPoint mjolnir_topoint(lua_State* L, int idx) {
    luaL_checktype(L, idx, LUA_TTABLE);
    CGFloat x = (lua_getfield(L, idx, "x"), luaL_checknumber(L, -1));
    CGFloat y = (lua_getfield(L, idx, "y"), luaL_checknumber(L, -1));
    lua_pop(L, 2);
    return NSMakePoint(x, y);
}

static void mjolnir_pushpoint(lua_State* L, NSPoint point) {
    lua_newtable(L);
    lua_pushnumber(L, point.x); lua_setfield(L, -2, "x");
    lua_pushnumber(L, point.y); lua_setfield(L, -2, "y");
}

/// mjolnir._asm.sys.mouse.get() -> point
///Function
/// Returns the current location of the mouse on the current screen as a point.
static int mouse_get(lua_State* L) {
    CGEventRef ourEvent = CGEventCreate(NULL);
    mjolnir_pushpoint(L, CGEventGetLocation(ourEvent));
    CFRelease(ourEvent);
    return 1;
}

/// mjolnir._asm.sys.mouse.set(point)
/// Function
/// Moves the mouse to the given location on the current screen.
static int mouse_set(lua_State* L) {
    CGWarpMouseCursorPosition(mjolnir_topoint(L, 1));
    return 0;
}

static const luaL_Reg mouseLib[] = {
    {"get", mouse_get},
    {"set", mouse_set},
    {NULL, NULL}
};

int luaopen_mjolnir__asm_sys_mouse_internal(lua_State* L) {
    luaL_newlib(L, mouseLib);
    return 1;
}


