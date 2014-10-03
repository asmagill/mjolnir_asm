#import <Cocoa/Cocoa.h>
#import <lauxlib.h>

/// mjolnir._asm.data.uuid() -> string
/// Function
/// Returns a newly generated UUID as a string
static int data_uuid(lua_State* L) {
    lua_pushstring(L, [[[NSUUID UUID] UUIDString] UTF8String]);
    return 1;
}

/// mjolnir._asm.data.pasteboard.getcontents() -> string
/// Function
/// Returns the contents of the pasteboard as a string, or nil if it can't be done
static int pasteboard_getcontents(lua_State* L) {
    lua_pushstring(L, [[[NSPasteboard generalPasteboard] stringForType:NSPasteboardTypeString] UTF8String]);
    return 1;
}

/// mjolnir._asm.data.pasteboard.setcontents(string) -> boolean
/// Function
/// Sets the contents of the pasteboard to the string value passed in. Returns success status as true or false.
static int pasteboard_setcontents(lua_State* L) {
    NSString* str = [NSString stringWithUTF8String:luaL_checkstring(L, 1)];

    [[NSPasteboard generalPasteboard] clearContents];
    BOOL result = [[NSPasteboard generalPasteboard] setString:str forType:NSPasteboardTypeString];

    lua_pushboolean(L, result);
    return 1;
}

/// mjolnir._asm.data.pasteboard.changecount() -> number
/// Function
/// The number of times the pasteboard owner changed (useful to see if the pasteboard was updated, by seeing if the value of this function changes).
static int pasteboard_changecount(lua_State* L) {
    lua_pushnumber(L, [[NSPasteboard generalPasteboard] changeCount]);
    return 1;
}

/// mjolnir._asm.data.userdata_tostring(userdata) -> string
/// Function
/// Returns the userdata object as a binary string.
static int ud_tostring (lua_State *L) {
    void *data = lua_touserdata(L,1);
    int sz;
    if (data == NULL) {
        lua_pushnil(L);
        lua_pushstring(L,"not a userdata type");
        return 2;
    } else {
        sz = lua_rawlen(L,1);
        lua_pushlstring(L,data,sz);
        return 1;
    }
}

static luaL_Reg pasteboardlib[] = {
    {"getcontents", pasteboard_getcontents},
    {"setcontents", pasteboard_setcontents},
    {"changecount", pasteboard_changecount},
    {NULL, NULL}
};

static const luaL_Reg datalib[] = {
    {"uuid", data_uuid},
    {"userdata_tostring", ud_tostring},
    {"pasteboard", NULL},   // Placeholder
    {NULL, NULL}
};

int luaopen_mjolnir__asm_data_internal(lua_State* L) {
    luaL_newlib(L, datalib);
    luaL_newlib(L, pasteboardlib);
    lua_setfield(L, -2, "pasteboard");
    return 1;
}
