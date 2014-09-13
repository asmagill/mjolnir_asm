#import <Cocoa/Cocoa.h>
#import <lauxlib.h>

/// mjolnir._asm.script.applescript(string) -> bool, string 
/// Runs the given AppleScript string. If it succeeds, returns true, and the NSObject return value as a string ; if it fails, returns false and a string containing information that hopefully explains why.
static int runapplescript(lua_State* L) {
    NSString* source = [NSString stringWithUTF8String:luaL_checkstring(L, 1)];

    NSAppleScript* script = [[NSAppleScript alloc] initWithSource:source];
    NSDictionary *__autoreleasing error;
    NSAppleEventDescriptor* result = [script executeAndReturnError:&error];

    lua_pushboolean(L, (result != nil));
    if (result == nil) 
//        mjolnir_push_luavalue_for_nsobject(L, error);
        lua_pushstring(L, [[NSString stringWithFormat:@"%@", error] UTF8String]);
    else
//        lua_pushstring(L, [[result stringValue] UTF8String]);
        lua_pushstring(L, [[NSString stringWithFormat:@"%@", result] UTF8String]);
    return 2;
}

static const luaL_Reg scriptlib[] = {
    {"applescript", runapplescript},
    {NULL, NULL}
};

int luaopen_mjolnir__asm_script_internal(lua_State* L) {
    luaL_newlib(L, scriptlib);

    return 1;
}
