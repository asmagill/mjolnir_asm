#import <Cocoa/Cocoa.h>
#import <lauxlib.h>

#define _VERSION_TAG_   "0.0.1-prealpha"

//  Add Base64 encode/decode?
//
// Need to add options flags and try moving helper funcs out...
//
//  {options} table for lua_to_NSObject
//      escape_table    (false)     = bool
//      escape_null     (false)     = bool
//      escape_bool     (false)     = bool
//      bad_key         ("error")   = "json"|"error"|"skip"|"tostring"
//      numeric_key     ("ok")      = "split"|"sparse"|"tostring"|"ok"
//
//  defaults:
//      set             escape_table = true, escape_null = true, numeric_key = "split"
//      encode_json     escape_table = true, numeric_key="split"
//
//  deal with loops:
//      a = { a=1,b=2,c=3} ; a.d = a ; json_encode(a) is pathological.  we need a way to deep scan for loops and non-data types.

id lua_to_NSObject(lua_State* L, int idx) {
    idx = lua_absindex(L,idx);
    switch (lua_type(L, idx)) {
        case LUA_TNUMBER: return @(lua_tonumber(L, idx));
        case LUA_TSTRING: return [NSString stringWithUTF8String: lua_tostring(L, idx)];
        case LUA_TNIL: return [NSNull null];
        case LUA_TBOOLEAN: return lua_toboolean(L, idx) ? (id)kCFBooleanTrue : (id)kCFBooleanFalse;  // should be a flag or option somewhere
//         case LUA_TBOOLEAN: return @{@"MJ_LUA_BOOL": @(lua_toboolean(L, idx))};
//         case LUA_TNIL: return @{@"MJ_LUA_NIL": @1};
        case LUA_TTABLE: {
            NSMutableDictionary* numerics = [NSMutableDictionary dictionary];
            NSMutableDictionary* nonNumerics = [NSMutableDictionary dictionary];
            NSMutableIndexSet*   numericKeys = [NSMutableIndexSet indexSet];
            NSMutableArray*      numberArray = [NSMutableArray array];
            lua_pushnil(L);
            while (lua_next(L, idx) != 0) {
                id key = lua_to_NSObject(L, -2);                                // need flag for "singleton" (string, number, etc.) or json?
                id val = lua_to_NSObject(L, lua_gettop(L));
                if ([key isKindOfClass: [NSNumber class]]) {
                    [numericKeys addIndex:[key intValue]];
                    [numerics setValue:val forKey:key];
                } else {
                    [nonNumerics setValue:val forKey:key];
                }
                lua_pop(L, 1);
            }
            if (numerics.count > 0) {
                for (int i = 1; i <= [numericKeys lastIndex]; i++) {
                    [numberArray addObject:(
                        [numerics objectForKey:[NSNumber numberWithInteger:i]] ?
                            [numerics objectForKey:[NSNumber numberWithInteger:i]] : [NSNull null]
                    )];
                }
                if (nonNumerics.count == 0)
                    return [numberArray copy];
            } else {
                return [nonNumerics copy];
            }
            NSMutableDictionary* unionBlob = [NSMutableDictionary dictionary];
            [unionBlob setValue:[NSArray arrayWithObjects:numberArray, nonNumerics, nil] forKey:@"MJ_LUA_TABLE"];
            return [unionBlob copy];
//             NSArray *keys = [numerics allKeys];
//             NSArray *values = [numerics allValues];
//             for (int i = 0; i < keys.count; i++) {
//                 [nonNumerics setValue:[values objectAtIndex:i] forKey:[keys objectAtIndex:i]];
//             }
//             return [nonNumerics copy];
        }
        default: { lua_pushliteral(L, "non-serializable object"); lua_error(L); }
    }
    return nil;
}

// NSUserDefaults to lua data type
//   data type (as deduced from 'man defaults') is missing... add it?
void NSObject_to_lua(lua_State* L, id obj) {
    NSLog(@"NSO2l: %@",obj) ;
    if (obj == nil || [obj isEqual: [NSNull null]]) { lua_pushnil(L); }
    else if ([obj isKindOfClass: [NSDictionary class]]) {
        BOOL handled = NO;
        if ([obj count] == 1) {
//             if ([obj objectForKey:@"MJ_LUA_BOOL"]) {
//                 NSNumber* boolean = [obj objectForKey:@"MJ_LUA_BOOL"];
//                 lua_pushboolean(L, [boolean boolValue]);
//                 handled = YES;
//             } else
            if ([obj objectForKey:@"MJ_LUA_NIL"]) {
                lua_pushnil(L);
                handled = YES;
            } else
            if ([obj objectForKey:@"MJ_LUA_TABLE"]) {
                NSArray* parts = [obj objectForKey:@"MJ_LUA_TABLE"] ;
                NSArray* numerics = [parts objectAtIndex:0] ;
                NSDictionary* nonNumerics = [parts objectAtIndex:1] ;
                lua_newtable(L);
                int i = 0;
                for (id item in numerics) {
                    NSObject_to_lua(L, item);
                    lua_rawseti(L, -2, ++i);
                }
                NSArray *keys = [nonNumerics allKeys];
                NSArray *values = [nonNumerics allValues];
                for (int i = 0; i < keys.count; i++) {
                    NSObject_to_lua(L, [keys objectAtIndex:i]);
                    NSObject_to_lua(L, [values objectAtIndex:i]);
                    lua_settable(L, -3);
                }
                handled = YES;
            }
        }
        if (!handled) {
            NSArray *keys = [obj allKeys];
            NSArray *values = [obj allValues];
            lua_newtable(L);
            for (int i = 0; i < keys.count; i++) {
                NSObject_to_lua(L, [keys objectAtIndex:i]);
                NSObject_to_lua(L, [values objectAtIndex:i]);
                lua_settable(L, -3);
            }
        }
    } else if ([obj isKindOfClass: [NSNumber class]]) {
        NSNumber* number = obj;
        if (obj == (id)kCFBooleanTrue)
            lua_pushboolean(L, YES);
        else if (obj == (id)kCFBooleanFalse)
            lua_pushboolean(L, NO);
        else
            lua_pushnumber(L, [(NSNumber*)obj doubleValue]);
    } else if ([obj isKindOfClass: [NSString class]]) {
        NSString* string = obj;
        lua_pushstring(L, [string UTF8String]);
    } else if ([obj isKindOfClass: [NSArray class]]) {
        int i = 0;
        NSArray* list = obj;
        lua_newtable(L);
        for (id item in list) {
            NSObject_to_lua(L, item);
            lua_rawseti(L, -2, ++i);
        }
    } else if ([obj isKindOfClass: [NSDate class]]) {
        lua_pushnumber(L, [(NSDate *) obj timeIntervalSince1970]);
    } else if ([obj isKindOfClass: [NSData class]]) {
        lua_pushlstring(L, [obj bytes], [obj length]) ;
    } else {
        lua_pushstring(L, [[NSString stringWithFormat:@"<Object> : %@", obj] UTF8String]) ;
    }
}

static const luaL_Reg settingslib[] = {
//    {"_version", NULL},
    {NULL, NULL}
};

int luaopen_mjolnir__asm_internal(lua_State* L) {
    luaL_newlib(L, settingslib);
    lua_pushliteral(L, _VERSION_TAG_) ;
    lua_setfield(L, -2, "_version") ;
    return 1;
}
