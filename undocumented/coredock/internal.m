#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import <lauxlib.h>
#import "coredock.h"

/// mjolnir._asm.undocumented.coredock.get_tilesize() -> float
/// Function
/// Returns the Dock icon tile size as a number between 0 and 1.
static int coredock_get_tilesize(lua_State* L) {
    lua_pushnumber(L, (float) CoreDockGetTileSize());

    return 1;
}

/// mjolnir._asm.undocumented.coredock.set_tilesize(float)
/// Function
/// Sets the Dock icon tile size to a number between 0 and 1.
static int coredock_set_tilesize(lua_State* L) {
    float tileSize = (float) luaL_checknumber(L, -1);

    if (tileSize >= 0 && tileSize <= 1)
        CoreDockSetTileSize(tileSize);
    else
        return luaL_error(L,"tilesize must be a number between 0 and 1");

    return 0;
}

/// mjolnir._asm.undocumented.coredock.get_magnification_size() -> float
/// Function
/// Returns the Dock magnification size as a number between 0 and 1.
static int coredock_get_magnification_size(lua_State* L) {
    lua_pushnumber(L, (float) CoreDockGetMagnificationSize());

    return 1;
}

/// mjolnir._asm.undocumented.coredock.set_magnification_size(float)
/// Function
/// Sets the Dock icon magnification size to a number between 0 and 1.
static int coredock_set_magnification_size(lua_State* L) {
    float magSize = (float) luaL_checknumber(L, -1);

    if (magSize >= 0 && magSize <= 1)
        CoreDockSetMagnificationSize(magSize);
    else
        return luaL_error(L,"magnification_size must be a number between 0 and 1");

    return 0;
}

/// mjolnir._asm.undocumented.coredock.get_orientation() -> int
/// Function
/// Returns an integer indicating the orientation of the Dock.  You can reference `mjolnir._asm.undocumented.coredock.options.orientation[#]` to get a human-readable string indicating the orientation.
static int coredock_get_orientation(lua_State* L) {
    CoreDockOrientation ourOrientation;
    CoreDockPinning     ourPinning;

    CoreDockGetOrientationAndPinning(&ourOrientation, &ourPinning);
    lua_pushnumber(L, (int) ourOrientation);

    return 1;
}

/// mjolnir._asm.undocumented.coredock.set_orientation(orientation)
/// Function
/// Sets the Dock orientation to the position indicated by orientation. You can reference `mjolnir._asm.undocumented.coredock.options.orientation` to select the appropriate number for the desired orientation.
static int coredock_set_orientation(lua_State* L) {
    CoreDockOrientation ourOrientation = luaL_checkinteger(L, -1);
    CoreDockPinning     ourPinning = 0;

    CoreDockSetOrientationAndPinning(ourOrientation, ourPinning);
    return 0;
}

/// mjolnir._asm.undocumented.coredock.set_oandp(orientation, pinning)
/// Function
/// Sets the Dock orientation and pinning simultaneously to the placement indicated by orientation and pinning.
static int coredock_set_oandp(lua_State* L) {
    CoreDockOrientation ourOrientation = luaL_checkinteger(L, -2);
    CoreDockPinning     ourPinning = luaL_checkinteger(L, -1);

    CoreDockSetOrientationAndPinning(ourOrientation, ourPinning);
    return 0;
}

/// mjolnir._asm.undocumented.coredock.get_pinning() -> int
/// Function
/// Returns an integer indicating the pinning of the Dock.  You can reference `mjolnir._asm.undocumented.coredock.options.pinning[#]` to get a human-readable string indicating the pinning.
static int coredock_get_pinning(lua_State* L) {
    CoreDockOrientation ourOrientation;
    CoreDockPinning     ourPinning;

    CoreDockGetOrientationAndPinning(&ourOrientation, &ourPinning);
    lua_pushnumber(L, (int) ourPinning);

    return 1;
}

/// mjolnir._asm.undocumented.coredock.set_pinning(pinning)
/// Function
/// Sets the Dock pinning to the position indicated by pinning. You can reference `mjolnir._asm.undocumented.coredock.options.pinning` to select the appropriate number for the desired pinning.
static int coredock_set_pinning(lua_State* L) {
    CoreDockOrientation ourOrientation = 0;
    CoreDockPinning     ourPinning = luaL_checkinteger(L, -1);

    CoreDockSetOrientationAndPinning(ourOrientation, ourPinning);
    return 0;
}


/// mjolnir._asm.undocumented.coredock.get_magnification() -> bool
/// Function
/// Returns true or false, indicating whether Dock Magnification is turned on or not.
static int coredock_get_magnification(lua_State* L) {
    if (CoreDockIsMagnificationEnabled())
        lua_pushboolean(L, YES) ;
    else
        lua_pushboolean(L, NO) ;
    return 1;
}

/// mjolnir._asm.undocumented.coredock.set_magnification(bool)
/// Function
/// Set Dock Magnification to on (true) or off (false).
static int coredock_set_magnification(lua_State* L) {
    CoreDockSetMagnificationEnabled((Boolean) lua_toboolean(L, -1));
    return 0;
}

/// mjolnir._asm.undocumented.coredock.get_autohide() -> bool
/// Function
/// Returns true or false, indicating whether Dock Hiding is turned on or not.
static int coredock_get_autohide(lua_State* L) {
    if (CoreDockGetAutoHideEnabled())
        lua_pushboolean(L, YES) ;
    else
        lua_pushboolean(L, NO) ;
    return 1;
}

/// mjolnir._asm.undocumented.coredock.set_autohide(bool)
/// Function
/// Set Dock Hiding to on (true) or off (false).
static int coredock_set_autohide(lua_State* L) {

    CoreDockSetAutoHideEnabled((Boolean) lua_toboolean(L, -1));
    return 0;
}

/// mjolnir._asm.undocumented.coredock.get_animationeffect() -> int
/// Function
/// Returns an integer indicating the animation effect used for window hiding to the Dock.  You can reference `mjolnir._asm.undocumented.coredock.options.effect[#]` to get a human-readable string indicating the effect.
static int coredock_get_animationeffect(lua_State* L) {
    CoreDockEffect  ourEffect;

    CoreDockGetEffect(&ourEffect);
    lua_pushnumber(L, (int) ourEffect);

    return 1;
}

/// mjolnir._asm.undocumented.coredock.set_animationeffect(effect)
/// Function
/// Sets the Dock animation effect used when hiding windows. You can reference `mjolnir._asm.undocumented.coredock.options.effect` to select the appropriate number for the desired effect.
static int coredock_set_animationeffect(lua_State* L) {
    CoreDockEffect  ourEffect = luaL_checkinteger(L, -1);

    CoreDockSetEffect(ourEffect);
    return 0;
}

static const luaL_Reg coredock_lib[] = {
    {"get_tilesize",            coredock_get_tilesize},
    {"set_tilesize",            coredock_set_tilesize},
    {"get_orientation",         coredock_get_orientation},
    {"set_orientation",         coredock_set_orientation},
    {"set_oandp",               coredock_set_oandp},
    {"get_pinning",             coredock_get_pinning},
    {"set_pinning",             coredock_set_pinning},
    {"get_animationeffect",     coredock_get_animationeffect},
    {"set_animationeffect",     coredock_set_animationeffect},
    {"get_autohide",            coredock_get_autohide},
    {"set_autohide",            coredock_set_autohide},
    {"get_magnification",       coredock_get_magnification},
    {"set_magnification",       coredock_set_magnification},
    {"get_magnification_size",  coredock_get_magnification_size},
    {"set_magnification_size",  coredock_set_magnification_size},
//    {"options", NULL},
    {NULL, NULL}
};

/// mjolnir._asm.undocumented.coredock.options[]
/// Variable
/// Connivence array of all currently defined coredock options.
/// ~~~lua
///     options.orientation[]  -- an array of the orientation options available for `set_orientation_and_pinning`
///         top         -- put the dock at the top of the monitor
///         bottom      -- put the dock at the bottom of the monitor
///         left        -- put the dock at the left of the monitor
///         right       -- put the dock at the right of the monitor
///
///     options.pinning[]  -- an array of the pinning options available for `set_orientation_and_pinning`
///         start       -- pin the dock at the start of its orientation
///         middle      -- pin the dock at the middle of its orientation
///         end         -- pin the dock at the end of its orientation
///
///     options.effect[]   -- an array of the dock animation options for  `set_animationeffect`
///         genie       -- use the genie animation
///         scale       -- use the scale animation
///         suck        -- use the suck animation
/// ~~~
static void coredock_options (lua_State *L) {
    lua_newtable(L) ;
        lua_newtable(L) ;
            lua_pushinteger(L, kCoreDockOrientationTop);    lua_setfield(L, -2, "top") ;
            lua_pushinteger(L, kCoreDockOrientationBottom); lua_setfield(L, -2, "bottom") ;
            lua_pushinteger(L, kCoreDockOrientationLeft);   lua_setfield(L, -2, "left") ;
            lua_pushinteger(L, kCoreDockOrientationRight);  lua_setfield(L, -2, "right") ;
        lua_setfield(L, -2, "orientation");
        lua_newtable(L) ;
            lua_pushinteger(L, kCoreDockPinningStart);  lua_setfield(L, -2, "start") ;
            lua_pushinteger(L, kCoreDockPinningMiddle); lua_setfield(L, -2, "middle") ;
            lua_pushinteger(L, kCoreDockPinningEnd);    lua_setfield(L, -2, "end") ;
        lua_setfield(L, -2, "pinning");
        lua_newtable(L) ;
            lua_pushinteger(L, kCoreDockEffectGenie);   lua_setfield(L, -2, "genie") ;
            lua_pushinteger(L, kCoreDockEffectScale);   lua_setfield(L, -2, "scale") ;
            lua_pushinteger(L, kCoreDockEffectSuck);    lua_setfield(L, -2, "suck") ;
        lua_setfield(L, -2, "effect");
}

int luaopen_mjolnir__asm_undocumented_coredock_internal(lua_State* L) {
    luaL_newlib(L, coredock_lib);
    coredock_options(L) ;
    lua_setfield(L, -2, "options") ;

    return 1;
}
