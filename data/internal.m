#import <Cocoa/Cocoa.h>
#import <lauxlib.h>

static BOOL is_sequential_table(lua_State* L, int idx) {
    NSMutableIndexSet* iset = [NSMutableIndexSet indexSet];
    
    lua_pushnil(L);
    while (lua_next(L, idx) != 0) {
        if (lua_isnumber(L, -2)) {
            double i = lua_tonumber(L, -2);
            if (i >= 1 && i <= NSNotFound - 1)
                [iset addIndex:i];
        }
        lua_pop(L, 1);
    }
    
    return [iset containsIndexesInRange:NSMakeRange([iset firstIndex], [iset lastIndex] - [iset firstIndex] + 1)];
}

void mjolnir_push_luavalue_for_nsobject(lua_State* L, id obj) {
    if (obj == nil || [obj isEqual: [NSNull null]]) {
        lua_pushnil(L);
    }
    else if ([obj isKindOfClass: [NSDictionary class]]) {
        lua_newtable(L);
        NSDictionary* dict = obj;
        
        for (id key in dict) {
            mjolnir_push_luavalue_for_nsobject(L, key);
            mjolnir_push_luavalue_for_nsobject(L, [dict objectForKey:key]);
            lua_settable(L, -3);
        }
    }
    else if ([obj isKindOfClass: [NSNumber class]]) {
        if (obj == (id)kCFBooleanTrue)
            lua_pushboolean(L, YES);
        else if (obj == (id)kCFBooleanFalse)
            lua_pushboolean(L, NO);
        else
            lua_pushnumber(L, [(NSNumber*)obj doubleValue]);
    }
    else if ([obj isKindOfClass: [NSString class]]) {
        NSString* string = obj;
        lua_pushstring(L, [string UTF8String]);
    }
    else if ([obj isKindOfClass: [NSDate class]]) {
        // not used for json, only in applistener; this should probably be moved to helpers
        NSDate* string = obj;
        lua_pushstring(L, [[string description] UTF8String]);
    }
    else if ([obj isKindOfClass: [NSArray class]]) {
        lua_newtable(L);
        
        int i = 0;
        NSArray* list = obj;
        
        for (id item in list) {
            mjolnir_push_luavalue_for_nsobject(L, item);
            lua_rawseti(L, -2, ++i);
        }
    }
}

id mjolnir_nsobject_for_luavalue(lua_State* L, int idx) {
    idx = lua_absindex(L,idx);
    
    switch (lua_type(L, idx)) {
        case LUA_TNIL: return [NSNull null];
        case LUA_TNUMBER: return @(lua_tonumber(L, idx));
        case LUA_TBOOLEAN: return lua_toboolean(L, idx) ? (id)kCFBooleanTrue : (id)kCFBooleanFalse;
        case LUA_TSTRING: return [NSString stringWithUTF8String: lua_tostring(L, idx)];
        case LUA_TTABLE: {
            if (is_sequential_table(L, idx)) {
                NSMutableArray* array = [NSMutableArray array];
                
                for (int i = 0; i < lua_rawlen(L, idx); i++) {
                    lua_rawgeti(L, idx, i+1);
                    id item = mjolnir_nsobject_for_luavalue(L, -1);
                    lua_pop(L, 1);
                    
                    [array addObject:item];
                }
                return array;
            }
            else {
                NSMutableDictionary* dict = [NSMutableDictionary dictionary];
                lua_pushnil(L);
                while (lua_next(L, idx) != 0) {
                    if (!lua_isstring(L, -2)) {
                        lua_pushliteral(L, "json map key must be a string");
                        lua_error(L);
                    }
                    
                    id key = mjolnir_nsobject_for_luavalue(L, -2);
                    id val = mjolnir_nsobject_for_luavalue(L, -1);
                    [dict setObject:val forKey:key];
                    lua_pop(L, 1);
                }
                return dict;
            }
        }
        default: {
            lua_pushliteral(L, "non-serializable object given to json");
            lua_error(L);
        }
    }
    // unreachable
    return nil;
}

/// mjolnir._asm.data.uuid() -> string
/// Function
/// Returns a newly generated UUID as a string
static int data_uuid(lua_State* L) {
    lua_pushstring(L, [[[NSUUID UUID] UUIDString] UTF8String]);
    return 1;
}

/// mjolnir._asm.data.json.encode(val[, prettyprint?]) -> str
/// Function
/// Returns a JSON string representing the given table; if prettyprint is true, the resulting string will be quite beautiful.
static int json_encode(lua_State* L) {
    if lua_istable(L, 1) {
        id obj = mjolnir_nsobject_for_luavalue(L, 1);
    
        NSJSONWritingOptions opts = 0;
        if (lua_toboolean(L, 2))
            opts = NSJSONWritingPrettyPrinted;
    
        NSError* __autoreleasing error;
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
        lua_pop(L, 1) ;
        lua_pushliteral(L, "non-table object given to json");
        lua_error(L);
        return 0;
    }        
}

/// mjolnir._asm.data.json.decode(str) -> val
/// Function
/// Returns a Lua value representing the given JSON string.
static int json_decode(lua_State* L) {
    const char* s = luaL_checkstring(L, 1);
    NSData* data = [[NSString stringWithUTF8String:s] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* __autoreleasing error;
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (obj) {
        mjolnir_push_luavalue_for_nsobject(L, obj);
        return 1;
    }
    else {
        lua_pushstring(L, [[error localizedDescription] UTF8String]);
        lua_error(L);
        return 0; // unreachable
    }
}

/// mjolnir._asm.data.clipboard.stringcontents() -> string
/// Function
/// Returns the contents of the pasteboard as a string, or nil if it can't be done
static int pasteboard_stringcontents(lua_State* L) {
    lua_pushstring(L, [[[NSPasteboard generalPasteboard] stringForType:NSPasteboardTypeString] UTF8String]);
    return 1;
}

/// mjolnir._asm.data.clipboard.changecount() -> number
/// Function
/// The number of times the pasteboard owner changed
/// (useful to see if the pasteboard was updated, by seeing if the value of this function changes).
static int pasteboard_changecount(lua_State* L) {
    lua_pushnumber(L, [[NSPasteboard generalPasteboard] changeCount]);
    return 1;
}


static luaL_Reg pasteboardlib[] = {
    {"getcontents", pasteboard_stringcontents},
    {"changecount", pasteboard_changecount},
    {NULL, NULL}
};

static const luaL_Reg jsonlib[] = {
    {"encode", json_encode},
    {"decode", json_decode},
    {NULL, NULL}
};

static const luaL_Reg datalib[] = {
    {"uuid", data_uuid},
    {"json", NULL},         // Placeholder
    {"clipboard", NULL},    // Placeholder
    {NULL, NULL}
};

int luaopen_mjolnir__asm_data_internal(lua_State* L) {
    luaL_newlib(L, datalib);
    luaL_newlib(L, jsonlib);
    lua_setfield(L, -2, "json");
    luaL_newlib(L, pasteboardlib);
    lua_setfield(L, -2, "clipboard");
    return 1;
}
