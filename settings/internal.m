#import <Cocoa/Cocoa.h>
#import <lauxlib.h>

/*

 encoding rules:

 nil = @{}
 number = NSNumber
 string = NSString
 boolean = @{@"bool", @(bool)}
 table = @[ k, v, ... ]

 No.  NIL and Bool already changed.
 need to figure out how to differentiate tables and arrays
 separate get/set?

 use json encoding by default?

 */

id settings_nsobject_for_luavalue(lua_State* L, int idx) {
    switch (lua_type(L, idx)) {
        case LUA_TNIL: return @{@"MJ_LUA_NIL": @1};
        case LUA_TNUMBER: return @(lua_tonumber(L, idx));
        case LUA_TBOOLEAN: return @{@"MJ_LUA_BOOL": @(lua_toboolean(L, idx))};
        case LUA_TSTRING: return [NSString stringWithUTF8String: lua_tostring(L, idx)];
        case LUA_TTABLE: {
            NSMutableArray* list = [NSMutableArray array];
            lua_pushnil(L);
            while (lua_next(L, idx) != 0) {
                id key = settings_nsobject_for_luavalue(L, -2);
                id val = settings_nsobject_for_luavalue(L, -1);
                [list addObject: key];
                [list addObject: val];
                lua_pop(L, 1);
            }
//             lua_pushnil(L);
//             while (lua_next(L, idx) != 0) {
//                 id key = settings_nsobject_for_luavalue(L, -2);
//                 id val = settings_nsobject_for_luavalue(L, -1);
//                 [list setObject:val forKey:key];
//                 lua_pop(L, 1);
//             }
            return [list copy];
        }
        default: {
            lua_pushliteral(L, "non-serializable object given to settings");
            lua_error(L);
        }
    }
    // unreachable
    return nil;
}

void settings_push_luavalue_for_nsobject(lua_State* L, id obj) {
    if (obj == nil) {
        // not set yet
        lua_pushnil(L);
    }
    else if ([obj isKindOfClass: [NSDictionary class]]) {
        BOOL handled = NO;

        if ([obj count] == 1) {
            if ([obj objectForKey:@"MJ_LUA_BOOL"]) {
                NSNumber* boolean = [obj objectForKey:@"MJ_LUA_BOOL"];
                lua_pushboolean(L, [boolean boolValue]);
                handled = YES;
            } else if ([obj objectForKey:@"MJ_LUA_NIL"]) {
                lua_pushnil(L);
                handled = YES;
            }
        }

        if (!handled) {
            NSArray *keys = [obj allKeys];
            NSArray *values = [obj allValues];

            lua_newtable(L);
            for (int i = 0; i < keys.count; i++) {
                settings_push_luavalue_for_nsobject(L, [keys objectAtIndex:i]);
                settings_push_luavalue_for_nsobject(L, [values objectAtIndex:i]);
                lua_settable(L, -3);
            }
        }
    }
    else if ([obj isKindOfClass: [NSNumber class]]) {
        NSNumber* number = obj;
        lua_pushnumber(L, [number doubleValue]);
    }
    else if ([obj isKindOfClass: [NSString class]]) {
        NSString* string = obj;
        lua_pushstring(L, [string UTF8String]);
    }
    else if ([obj isKindOfClass: [NSArray class]]) {
        NSArray* list = obj;
        lua_newtable(L);

        for (int i = 0; i < [list count]; i ++) {
            id val = [list objectAtIndex:i];
            lua_pushnumber(L, i + 1);
            settings_push_luavalue_for_nsobject(L, val);
            lua_settable(L, -3);
        }
    }
}


/// mjolnir._asm.settings.set(key, val)
/// Function
/// Saves the given value for the string key; value must be a string, number, boolean, nil, or a table of any of these, recursively.
static int settings_set(lua_State* L) {
    NSString* key = [NSString stringWithUTF8String: luaL_checkstring(L, 1)];
    id val = settings_nsobject_for_luavalue(L, 2);
    [[NSUserDefaults standardUserDefaults] setObject:val forKey:key];
    return 0;
}

/// mjolnir._asm.settings.get(key) -> val
/// Function
/// Gets the Lua value for the given string key.
static int settings_get(lua_State* L) {
    NSString* key = [NSString stringWithUTF8String: luaL_checkstring(L, 1)];
    id val = [[NSUserDefaults standardUserDefaults] objectForKey:key];

    settings_push_luavalue_for_nsobject(L, val);
    return 1;
}

/// mjolnir._asm.settings.clear(key)
/// Function
/// Removes the given string key from storage.
static int settings_clear(lua_State* L) {
    NSString* key = [NSString stringWithUTF8String: luaL_checkstring(L, 1)];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];

    return 0;
}

/// mjolnir._asm.settings.getall()
/// Function
/// Returns all defined values within Mjolnir's defaults
static int settings_getall(lua_State* L) {
    NSArray *keys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
    NSArray *values = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allValues];

    lua_newtable(L);
    for (int i = 0; i < keys.count; i++) {
//         NSLog(@"%@: %@", [keys objectAtIndex:i], [values objectAtIndex:i]);
//         lua_pushnumber(L, i+1) ;
        settings_push_luavalue_for_nsobject(L, [keys objectAtIndex:i]);
        settings_push_luavalue_for_nsobject(L, [values objectAtIndex:i]);
        lua_settable(L, -3);
    }

    return 1;
}

static const luaL_Reg settingslib[] = {
    {"set", settings_set},
    {"get", settings_get},
    {"clear", settings_clear},
    {"getall", settings_getall},
    {NULL, NULL}
};

int luaopen_mjolnir__asm_settings_internal(lua_State* L) {
    luaL_newlib(L, settingslib);
    return 1;
}
