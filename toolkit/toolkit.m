#import <lauxlib.h>

/// mjolnir._asm.toolkit.userdata_to_string(userdata) -> string
/// Function
/// Returns the userdata object as a binary string.
static int userdata_to_string (lua_State *L) { 
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

static const luaL_Reg toolkitlib[] = { 
    {"userdata_to_string", userdata_to_string}, 
    {NULL, NULL} 
}; 

int luaopen_mjolnir__asm_toolkit_internal(lua_State* L) {
    luaL_newlib(L, toolkitlib);
    return 1;

}
