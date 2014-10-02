/// mjolnir._asm.settings.json_encode(val[, prettyprint?]) -> str
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
        lua_pop(L, 1) ;
        lua_pushliteral(L, "non-table object given to json");
        lua_error(L);
        return 0;
    }
}

///  mjolnir._asm.settings.json_decode(str) -> val
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

