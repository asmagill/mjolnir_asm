#import <Cocoa/Cocoa.h>
#import <lauxlib.h>

/// mjolnir._asm.data.uuid() -> string
/// Function
/// Returns a newly generated UUID as a string
static int data_uuid(lua_State* L) {
    lua_pushstring(L, [[[NSUUID UUID] UUIDString] UTF8String]);
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

static const luaL_Reg datalib[] = {
    {"uuid", data_uuid},
    {"userdata_tostring", ud_tostring},
    {NULL, NULL}
};

int luaopen_mjolnir__asm_data_internal(lua_State* L) {
    luaL_newlib(L, datalib);
    return 1;
}
