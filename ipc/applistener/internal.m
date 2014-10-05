#import <Cocoa/Cocoa.h>
#import <lauxlib.h>

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

@interface MjolnirAppListenerClass : NSObject
@property lua_State* L;
@property int fn;
@property int ref;
@end
@implementation MjolnirAppListenerClass
- (void) heard:(NSNotification*)note {
    lua_State* L = self.L;
    lua_rawgeti(L, LUA_REGISTRYINDEX, self.fn);

    lua_pushstring(L, [[note name] UTF8String]);
    mjolnir_push_luavalue_for_nsobject(L, [note object]);
    mjolnir_push_luavalue_for_nsobject(L, [note userInfo]);
    lua_call(L, 3, 0);
}
@end

static NSMutableIndexSet* listenerhandlers;

static int store_applistener(lua_State* L, int idx) {
    lua_pushvalue(L, idx);
    int x = luaL_ref(L, LUA_REGISTRYINDEX);
    [listenerhandlers addIndex: x];
    return x;
}

static void remove_applistener(lua_State* L, int x) {
    luaL_unref(L, LUA_REGISTRYINDEX, x);
    [listenerhandlers removeIndex: x];
}

// mjolnir._asm.applistener.new(fn(notification)) -> applistener
// Registers a listener function for inter-app notifications.
static int applistener_new(lua_State* L) {
    luaL_checktype(L, 1, LUA_TFUNCTION);

    MjolnirAppListenerClass* listener = [[MjolnirAppListenerClass alloc] init];
    listener.L = L;

    lua_pushvalue(L, 1);
    listener.fn = luaL_ref(L, LUA_REGISTRYINDEX);

    void** ud = lua_newuserdata(L, sizeof(id*));
    *ud = (__bridge void*)listener;

    luaL_getmetatable(L, "mjolnir._asm.applistener");
    lua_setmetatable(L, -2);

    return 1;
}

/// mjolnir._asm.applistener:start()
/// Method
/// Starts listening for notifications.
static int applistener_start(lua_State* L) {
    MjolnirAppListenerClass* applistener = (__bridge MjolnirAppListenerClass*)(*(void**)luaL_checkudata(L, 1, "mjolnir._asm.applistener"));
    [[NSDistributedNotificationCenter defaultCenter] addObserver:applistener selector:@selector(heard:) name:nil object:nil];
    applistener.ref = store_applistener(L, 1);
    return 0;
}

/// mjolnir._asm.applistener:stop()
/// Method
/// Stops listening for notifications.
static int applistener_stop(lua_State* L) {
    MjolnirAppListenerClass* applistener = (__bridge MjolnirAppListenerClass*)(*(void**)luaL_checkudata(L, 1, "mjolnir._asm.applistener"));
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:applistener];
    remove_applistener(L, applistener.ref);
    return 0;
}

static const luaL_Reg applistenerlib[] = {
    {"_new", applistener_new},
    {"start", applistener_start},
    {"stop", applistener_stop},
    {"__gc", applistener_stop},
    {NULL, NULL}
};

int luaopen_mjolnir__asm_applistener_internal(lua_State* L) {
    luaL_newlib(L, applistenerlib);

    // applistener.__index = applistener
    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");

    // put applistener in registry; necessary for luaL_checkudata()
    lua_pushvalue(L, -1);
    lua_setfield(L, LUA_REGISTRYINDEX, "mjolnir._asm.applistener");

    return 1;
}
