#import <Cocoa/Cocoa.h>
#import <lauxlib.h>
#import <dlfcn.h>

static void*        _asmLib ;

static void* link_extlib(lua_State* L, NSString *Name) {
    const char* cmdLine = [
        [[NSString alloc]
            initWithFormat:@"return package.searchpath(\"%@\",package.cpath)", Name]
        UTF8String
    ];
    int error = luaL_loadbuffer(L, cmdLine, strlen(cmdLine), "internal") || lua_pcall(L, 0, 1, 0);
    if (error) { lua_error(L); }
    void* ourLib = dlopen(luaL_checkstring(L, -1), RTLD_LAZY);
    lua_pop(L, 1);
    if (!ourLib) { lua_pushstring(L, dlerror()); lua_error(L); }
    return ourLib;
}

// Define wrappers for the functions from the external library that we want:

static id lua_to_NSObject(lua_State* L, int idx) {
    id (*f)() = dlsym(_asmLib, "lua_to_NSObject"); return (*f)(L, idx);
}

static void NSObject_to_lua(lua_State* L, id obj) {
    void (*f)() = dlsym(_asmLib, "NSObject_to_lua"); return (*f)(L, obj);
}

// Now the meat of the module...

/// mjolnir._asm.data.json.encode(val[, prettyprint?]) -> str
/// Function
/// Returns a JSON string representing the given value; if prettyprint is true, the resulting string will formatted for readability.  Value must be a table.
///
///  Useful for storing some of the more complex lua table structures as a persistent setting.
static int json_encode(lua_State* L) {
    if lua_istable(L, 1) {
        id obj = lua_to_NSObject(L, 1);

        NSJSONWritingOptions opts = 0;
        if (lua_toboolean(L, 2))
            opts = NSJSONWritingPrettyPrinted;

        if ([NSJSONSerialization isValidJSONObject:obj]) {
            NSError* error;
            NSData* data = [NSJSONSerialization dataWithJSONObject:obj options:opts error:&error];

            if (data) {
                NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                lua_pushstring(L, [str UTF8String]);
                return 1;
            }
            else {
                lua_pushstring(L, [[error localizedDescription] UTF8String]);
                lua_error(L);
                return 0; // unreachable
            }
        } else {
            luaL_error(L, "object cannot be encoded as a json string") ;
            return 0;
        }
    } else {
        lua_pop(L, 1) ;
        luaL_error(L, "non-table object given to json encoder");
        return 0;
    }
}

/// mjolnir._asm.data.json.decode(str) -> val
/// Function
/// Returns a Lua value representing the given JSON string.
///
///  Useful for retrieving some of the more complex lua table structures as a persistent setting.
static int json_decode(lua_State* L) {
    const char* s = luaL_checkstring(L, 1);
    NSData* data = [[NSString stringWithUTF8String:s] dataUsingEncoding:NSUTF8StringEncoding];

    NSError* error;
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

    if (obj) {
        NSObject_to_lua(L, obj);
        return 1;
    }
    else {
        lua_pushstring(L, [[error localizedDescription] UTF8String]);
        lua_error(L);
        return 0; // unreachable
    }
}

// Release shared library upon collection of this module
static int meta_gc(lua_State* L) {
    if (_asmLib) { dlclose(_asmLib); }
    return 0;
}

// Functions for returned object when module loads
static const luaL_Reg jsonLib[] = {
    {"encode",  json_encode},
    {"decode",  json_decode},
    {NULL,      NULL}
};

// Metatable for returned object when module loads
static const luaL_Reg meta_gcLib[] = {
    {"__gc",    meta_gc},
    {NULL,      NULL}
};

int luaopen_mjolnir__asm_data_json_internal(lua_State* L) {
    // link to external library, mjolnir._asm.internal.so
    _asmLib = link_extlib(L, @"mjolnir._asm.internal") ;

    // setup the module
    luaL_newlib(L, jsonLib);
        luaL_newlib(L, meta_gcLib);
        lua_setmetatable(L, -2);

    return 1;
}
