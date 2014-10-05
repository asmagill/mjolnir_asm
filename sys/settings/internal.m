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

/// mjolnir._asm.settings.set(key, val)
/// Function
/// Saves the given value for the given string key; value must be a string, number, boolean, nil, or a table of any of these, recursively.  This function cannot set NSUserDefault types of Data or Date.  See `settings.set_data` and `settings.set_date`.
static int mjolnir_set(lua_State* L) {
    NSString* key = [NSString stringWithUTF8String: luaL_checkstring(L, 1)];
    id val = lua_to_NSObject(L, 2);
    [[NSUserDefaults standardUserDefaults] setObject:val forKey:key];
    return 0;
}

/// mjolnir._asm.settings.set_data(key, val)
/// Function
/// Saves the given value as raw binary data for the string key.  A raw binary string differs from a traditional string in that it may contain embedded null values and other unprintable bytes (characters) which might otherwise be lost or mangled if treated as a traditional C-Style (null terminated) string.
static int mjolnir_set_data(lua_State* L) {
    NSString* key = [NSString stringWithUTF8String: luaL_checkstring(L, 1)];
    if (lua_type(L,2) == LUA_TSTRING) {
        const char* data = lua_tostring(L,2) ;
        int sz = lua_rawlen(L, 2) ;
        NSData* myData = [[NSData alloc] initWithBytes:data length:sz] ;
        [[NSUserDefaults standardUserDefaults] setObject:myData forKey:key];
    } else {
        luaL_error(L, "second argument not (binary data encapsulated as) a string") ;
    }

    return 0 ;
}

/// mjolnir._asm.settings.set_date(key, val)
/// Function
/// Saves the given value as a date for the given string key.  If val is a number, then it represents the number of seconds since 1970-01-01 00:00:00 +0000 (e.g. `os.time()`).  If it is a string, it should be in the format of 'YYYY-MM-DD HH:MM:SS ±HHMM' (e.g. `os.date("%Y-%m-%d %H:%M:%S %z")`).
static int mjolnir_set_date(lua_State* L) {
    NSString* key = [NSString stringWithUTF8String: luaL_checkstring(L, 1)];
    NSDate* myDate = lua_isnumber(L, 2) ? [[NSDate alloc] initWithTimeIntervalSince1970:(NSTimeInterval) lua_tonumber(L,2)] :
                     lua_isstring(L, 2) ? [[NSDate alloc] initWithString:[NSString stringWithUTF8String:lua_tostring(L, 2)]] : nil ;
    if (myDate) {
        [[NSUserDefaults standardUserDefaults] setObject:myDate forKey:key];
    } else {
        luaL_error(L, "Not a date type -- Number: # of seconds since 1970-01-01 00:00:00 +0000 or String: in the format of 'YYYY-MM-DD HH:MM:SS ±HHMM'") ;
    }
    return 0 ;
}

/// mjolnir._asm.settings.get(key) -> val
/// Function
/// Gets the Lua value for the given string key.  This function can retrieve NSUserDefault types of Data and Date, as well as serializable Lua types.
static int mjolnir_get(lua_State* L) {
    NSString* key = [NSString stringWithUTF8String: luaL_checkstring(L, 1)];
    id val = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSObject_to_lua(L, val);
    return 1;
}

/// mjolnir._asm.settings.clear(key) -> bool
/// Function
/// Attempts to remove the given string key from storage, returning `true` on success or `false` on failure (e.g. `key` does not exist or is administratively managed).
static int mjolnir_clear(lua_State* L) {
    NSString* key = [NSString stringWithUTF8String: luaL_checkstring(L, 1)];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:key] && ![[NSUserDefaults standardUserDefaults] objectIsForcedForKey:key]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        lua_pushboolean(L, YES) ;
    } else
        lua_pushboolean(L, NO) ;
    return 1;
}

/// mjolnir._asm.settings.getkeys() -> []
/// Function
/// Returns a table of all defined keys within the Mjolnir user defaults, as an array and as a list of keys.  Use `ipairs(settings.getkeys())` to iterate through the list of all settings which have been defined or `settings.getkeys()["key"]` to test for the existence of a key.
static int mjolnir_getkeys(lua_State* L) {
    NSArray *keys = [[[NSUserDefaults standardUserDefaults] persistentDomainForName: [[NSBundle mainBundle] bundleIdentifier]] allKeys];
    lua_newtable(L);
    for (int i = 0; i < keys.count; i++) {
        lua_pushnumber(L, i+1) ;
        NSObject_to_lua(L, [keys objectAtIndex:i]);
        lua_settable(L, -3);
        NSObject_to_lua(L, [keys objectAtIndex:i]);
        lua_pushboolean(L, YES) ;
        lua_settable(L, -3);
    }
    return 1;
}

// Release shared library upon collection of this module
static int meta_gc(lua_State* L) {
    if (_asmLib) { dlclose(_asmLib); }
    return 0;
}

// Functions for returned object when module loads
static const luaL_Reg settingslib[] = {
    {"set",         mjolnir_set},
    {"set_data",    mjolnir_set_data},
    {"set_date",    mjolnir_set_date},
    {"get",         mjolnir_get},
    {"clear",       mjolnir_clear},
    {"getkeys",     mjolnir_getkeys},
    {NULL, NULL}
};

// Metatable for returned object when module loads
static const luaL_Reg meta_gcLib[] = {
    {"__gc",    meta_gc},
    {NULL,      NULL}
};

int luaopen_mjolnir__asm_settings_internal(lua_State* L) {
    // link to external library, mjolnir._asm.internal.so
    _asmLib = link_extlib(L, @"mjolnir._asm.internal") ;

    // setup the module
    luaL_newlib(L, settingslib);
        luaL_newlib(L, meta_gcLib);
        lua_setmetatable(L, -2);

    return 1;
}
