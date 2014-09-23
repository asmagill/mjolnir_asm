#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import <lauxlib.h>
#import "spaces.h"

static NSNumber* getcurrentspace(void) {
    NSArray* spaces = (__bridge_transfer NSArray*)CGSCopySpaces(_CGSDefaultConnection(), kCGSSpaceCurrent);
    return [spaces objectAtIndex:0];
}

static NSArray* getspaces(void) {
    NSArray* spaces = (__bridge_transfer NSArray*)CGSCopySpaces(_CGSDefaultConnection(), kCGSSpaceAll);
    NSMutableArray* userSpaces = [NSMutableArray array];

    for (NSNumber* space in [spaces reverseObjectEnumerator]) {
        if (CGSSpaceGetType(_CGSDefaultConnection(), [space unsignedLongLongValue]) != kCGSSpaceSystem)
            [userSpaces addObject:space];
    }

    return userSpaces;
}

/// mjolnir._asm.hydra.undocumented_spaces.count() -> number
/// Function
/// The number of spaces you currently have.
static int spaces_count(lua_State* L) {
    lua_pushnumber(L, [getspaces() count]);
    return 1;
}

/// mjolnir._asm.hydra.undocumented.spaces_currentspace() -> number
/// Function
/// The index of the space you're currently on, 1-indexed (as usual).
static int spaces_currentspace(lua_State* L) {
    NSUInteger idx = [getspaces() indexOfObject:getcurrentspace()];

    if (idx == NSNotFound)
        lua_pushnil(L);
    else
        lua_pushnumber(L, idx + 1);

    return 1;
}

/// mjolnir._asm.hydra.undocumented.spaces_movetospace(number)
/// Function
/// Switches to the space at the given index, 1-indexed (as usual).
/// Note that this may cause unexpected or odd behavior in spaces changes under 10.9 and 10.10.  A more robust solution is being looked into.
static int spaces_movetospace(lua_State* L) {
    NSArray* spaces = getspaces();

    NSInteger toidx = luaL_checknumber(L, 1) - 1;
    NSInteger fromidx = [spaces indexOfObject:getcurrentspace()];

    BOOL worked = NO;

    if (toidx < 0 || fromidx == NSNotFound || toidx == fromidx || toidx >= [spaces count])
        goto finish;

    NSUInteger from = [[spaces objectAtIndex:fromidx] unsignedLongLongValue];
    NSUInteger to = [[spaces objectAtIndex:toidx] unsignedLongLongValue];

    CGSHideSpaces(_CGSDefaultConnection(), @[@(from)]);
    CGSShowSpaces(_CGSDefaultConnection(), @[@(to)]);
    CGSManagedDisplaySetCurrentSpace(_CGSDefaultConnection(), kCGSPackagesMainDisplayIdentifier, to);

    worked = YES;

finish:

    lua_pushboolean(L, worked);
    return 1;
}

/// mjolnir._asm.hydra.undocumented.setosxshadows(bool)
/// Function
/// Sets whether OSX apps have shadows.
static int setosxshadows(lua_State* L) {
    BOOL on = lua_toboolean(L, 1);

    typedef enum _CGSDebugOptions {
        kCGSDebugOptionNone = 0,
        kCGSDebugOptionNoShadows = 0x4000
    } CGSDebugOptions;

    extern void CGSGetDebugOptions(CGSDebugOptions *options);
    extern void CGSSetDebugOptions(CGSDebugOptions options);

    CGSDebugOptions options;
    CGSGetDebugOptions(&options);
    options = on ? options & ~kCGSDebugOptionNoShadows : options | kCGSDebugOptionNoShadows;
    CGSSetDebugOptions(options);

    return 0;
}

static luaL_Reg spaceslib[] = {
    {"spaces_count",        spaces_count},
    {"spaces_currentspace", spaces_currentspace},
    {"spaces_movetospace",  spaces_movetospace},
    {"setosxshadows",       setosxshadows},
    {NULL, NULL},
};

int luaopen_mjolnir__asm_hydra_undocumented_internal(lua_State* L) {
    luaL_newlib(L, spaceslib);
    return 1;
}
