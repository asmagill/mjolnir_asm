#import <Cocoa/Cocoa.h>
#import <lauxlib.h>

// void new_eventtap_event(lua_State* L, CGEventRef event);
void new_eventtap_event(lua_State* L, CGEventRef event) {
    CFRetain(event);
    *(CGEventRef*)lua_newuserdata(L, sizeof(CGEventRef*)) = event;

    luaL_getmetatable(L, "mjolnir._asm.eventtap.event");
    lua_setmetatable(L, -2);
}
// CGEventRef mjolnir_to_eventtap_event(lua_State* L, int idx);
CGEventRef mjolnir_to_eventtap_event(lua_State* L, int idx) {
    return *(CGEventRef*)luaL_checkudata(L, idx, "mjolnir._asm.eventtap.event");
}

typedef struct _eventtap_t {
    lua_State* L;
    bool running;
    int fn;
    int self;
    CGEventMask mask;
    CFMachPortRef tap;
    CFRunLoopSourceRef runloopsrc;
} eventtap_t;

static NSMutableIndexSet* eventhandlers;

static int store_event(lua_State* L, int idx) {
    lua_pushvalue(L, idx);
    int x = luaL_ref(L, LUA_REGISTRYINDEX);
    [eventhandlers addIndex: x];
    return x;
}

static void remove_event(lua_State* L, int x) {
    luaL_unref(L, LUA_REGISTRYINDEX, x);
    [eventhandlers removeIndex: x];
}

CGEventRef eventtap_callback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    eventtap_t* e = refcon;
    lua_State* L = e->L;

    lua_rawgeti(L, LUA_REGISTRYINDEX, e->fn);
    new_eventtap_event(L, event);

    lua_call(L, 1, 2);

    bool ignoreevent = lua_toboolean(L, -2);

    if (lua_istable(L, -1)) {
        lua_pushnil(L);
        while (lua_next(L, -2) != 0) {
            CGEventRef event = mjolnir_to_eventtap_event(L, -1);
            CGEventTapPostEvent(proxy, event);
            lua_pop(L, 1);
        }
    }

    lua_pop(L, 2);

    if (ignoreevent)
        return NULL;
    else
        return event;
}

// mjolnir._asm.eventtap.new(types, callback(event) -> ignoreevent, moreevents) -> eventtap
// Returns a new event tap with the given callback for the given event type; the eventtap not started automatically.
// The types param is a table which may contain values from table `eventtap.event.types`.
// The callback takes an event object as its only parameter. It can optionally return two values: if the first one is truthy, this event is deleted from the system input event stream and not seen by any other app; if the second one is a table of events, they will each be posted along with this event.
static int eventtap_new(lua_State* L) {
    luaL_checktype(L, 1, LUA_TTABLE);
    luaL_checktype(L, 2, LUA_TFUNCTION);

    eventtap_t* eventtap = lua_newuserdata(L, sizeof(eventtap_t));
    memset(eventtap, 0, sizeof(eventtap_t));

    eventtap->L = L;

    lua_pushnil(L);
    while (lua_next(L, 1) != 0) {
        if (lua_isnumber(L, -1)) {
            CGEventType type = lua_tonumber(L, -1);
            eventtap->mask ^= CGEventMaskBit(type);
        } else if (lua_isstring(L, -1)) {
            const char *label = lua_tostring(L, -1);
            if (strcmp(label, "all") == 0)
                eventtap->mask = kCGEventMaskForAllEvents ;
            else
                return luaL_error(L, "Invalid event type specified. Must be a table of numbers or {\"all\"}.") ;
        } else
            return luaL_error(L, "Invalid event types specified. Must be a table of numbers.") ;
        lua_pop(L, 1);
    }

    lua_pushvalue(L, 2);
    eventtap->fn = luaL_ref(L, LUA_REGISTRYINDEX);

    luaL_getmetatable(L, "mjolnir._asm.eventtap");
    lua_setmetatable(L, -2);

    return 1;
}

/// mjolnir._asm.eventtap:start()
/// Method
/// Starts an event tap; must be in stopped state.
static int eventtap_start(lua_State* L) {
    eventtap_t* e = luaL_checkudata(L, 1, "mjolnir._asm.eventtap");

    if (e->running)
        return 0;

    e->self = store_event(L, 1);
    e->running = true;
    e->tap = CGEventTapCreate(kCGSessionEventTap,
                              kCGHeadInsertEventTap,
                              kCGEventTapOptionDefault,
                              e->mask,
                              eventtap_callback,
                              e);

    CGEventTapEnable(e->tap, true);
    e->runloopsrc = CFMachPortCreateRunLoopSource(NULL, e->tap, 0);
    CFRunLoopAddSource(CFRunLoopGetMain(), e->runloopsrc, kCFRunLoopCommonModes);

    return 0;
}

/// mjolnir._asm.eventtap:stop()
/// Method
/// Stops an event tap; must be in started state.
static int eventtap_stop(lua_State* L) {
    eventtap_t* e = luaL_checkudata(L, 1, "mjolnir._asm.eventtap");

    if (!e->running)
        return 0;

    remove_event(L, e->self);
    e->running = false;

    CGEventTapEnable(e->tap, false);
    CFMachPortInvalidate(e->tap);
    CFRunLoopRemoveSource(CFRunLoopGetMain(), e->runloopsrc, kCFRunLoopCommonModes);
    CFRelease(e->runloopsrc);
    CFRelease(e->tap);

    return 0;
}

// /// eventtap.stopall()
// /// Stops all event taps; called automatically when the user's config reloads.
// static int eventtap_stopall(lua_State* L) {
//     lua_getglobal(L, "eventtap");
//     lua_getfield(L, -1, "stop");
//     mjolnir_remove_all_handlers(L, "mjolnir._asm.eventtap");
//     return 0;
// }

static int eventtap_gc(lua_State* L) {
    eventtap_t* eventtap = luaL_checkudata(L, 1, "mjolnir._asm.eventtap");
    if (eventtap->running) {
        remove_event(L, eventtap->self);
        eventtap->running = false;

        CGEventTapEnable(eventtap->tap, false);
        CFMachPortInvalidate(eventtap->tap);
        CFRunLoopRemoveSource(CFRunLoopGetMain(), eventtap->runloopsrc, kCFRunLoopCommonModes);
        CFRelease(eventtap->runloopsrc);
        CFRelease(eventtap->tap);
    }
    luaL_unref(L, LUA_REGISTRYINDEX, eventtap->fn);
    return 0;
}

static luaL_Reg eventtaplib[] = {
    // module methods
    {"_new", eventtap_new},
//     {"stopall", eventtap_stopall},

    // instance methods
    {"start", eventtap_start},
    {"stop", eventtap_stop},

    // metamethods
    {"__gc", eventtap_gc},

    // sentinel
    {}
};

int luaopen_mjolnir__asm_eventtap_internal(lua_State* L) {
    luaL_newlib(L, eventtaplib);

    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");

    lua_pushvalue(L, -1);
    lua_setfield(L, LUA_REGISTRYINDEX, "mjolnir._asm.eventtap");

    return 1;
}
