#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import <lauxlib.h>

//void NSLog(NSString* format, ...) {}

// Common Code

#define USERDATA_TAG    "mjolnir._asm.ui.notification"

static int store_udhandler(lua_State* L, NSMutableIndexSet* theHandler, int idx) {
    lua_pushvalue(L, idx);
    int x = luaL_ref(L, LUA_REGISTRYINDEX);
    [theHandler addIndex: x];
    return x;
}

static void remove_udhandler(lua_State* L, NSMutableIndexSet* theHandler, int x) {
    luaL_unref(L, LUA_REGISTRYINDEX, x);
    [theHandler removeIndex: x];
}

static void* push_udhandler(lua_State* L, int x) {
    lua_rawgeti(L, LUA_REGISTRYINDEX, x);
    return lua_touserdata(L, -1);
}

// Not so common code

static NSMutableIndexSet* notificationHandlers;

// Mjolnir's notification interface

@interface MJUserNotificationManager : NSObject
+ (MJUserNotificationManager*) sharedManager;
- (void) sendNotification:(NSString*)title handler:(dispatch_block_t)handler;
@end

@interface MJUserNotificationManager () <NSUserNotificationCenterDelegate>
@property NSMutableDictionary* callbacks;
@end

// Delegate for notifications

@interface noteDelegate : NSObject <NSUserNotificationCenterDelegate>
+ (noteDelegate*) sharedManagerForLua:(lua_State*)L;
- (void) sendNotification:(NSUserNotification*)note;
- (void) releaseNotification:(NSUserNotification*)note;
- (void) withdrawNotification:(NSUserNotification*)note;

@property (retain) NSMutableDictionary* ActiveCallbacks;
@property lua_State* L;
@end

static noteDelegate*                            notification_delegate ;
static id <NSUserNotificationCenterDelegate>    old_delegate ;

typedef struct _notification_t {
    bool                delivered;
    int                 fn;
    NSUserNotification* note;
    int                 registryHandle;
} notification_t;

@implementation noteDelegate

+ (noteDelegate*) sharedManagerForLua:(lua_State*)L {
    static noteDelegate* sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[noteDelegate alloc] init];
        sharedManager.ActiveCallbacks = [[NSMutableDictionary dictionary] retain];
        sharedManager.L = L;
        [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:sharedManager];
    });
    return sharedManager;
}

- (void) sendNotification:(NSUserNotification*)note {
// I think, if you modify a notification (even release), then you have to show it again in order to allow withdraw
// to withdraw it.  At any rate, allow reuse, even if the callback is no longer functional.
    NSLog(@"in sendNotification");
//     NSNumber* value = [[note userInfo] objectForKey:@"handler"];
//     NSLog(@"   value = %@", value);
//     if (value) {
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification: note];
//     } else {
//         NSLog(@"   no tagged handler -- not ours?");
//     }
}

- (void) releaseNotification:(NSUserNotification*)note {
    NSLog(@"in releaseNotification");
    NSNumber* value = [[note userInfo] objectForKey:@"handler"];
    NSLog(@"   value = %@", value);
    if (value) {
        [self.ActiveCallbacks removeObjectForKey:[[note userInfo] objectForKey:@"handler"]];
        note.userInfo = @{};
    } else {
        NSLog(@"   no tagged handler -- already released?");
    }
}

- (void) withdrawNotification:(NSUserNotification*)note {
    NSLog(@"in withdrawNotification");
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeDeliveredNotification: note];
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeScheduledNotification: note];
}

// Notification delivered to Notification Center
- (void)userNotificationCenter:(NSUserNotificationCenter *)center
    didDeliverNotification:(NSUserNotification *)notification {
        NSLog(@"in didDeliverNotification");
        NSNumber* value = [[notification userInfo] objectForKey:@"handler"];
        NSLog(@"   value = %@", value);
        if (value) {
            [self.ActiveCallbacks setObject:@1 forKey:value];
            int myHandle = [value intValue];
            lua_State* L = self.L;
            lua_rawgeti(L, LUA_REGISTRYINDEX, (int)myHandle);
            notification_t* thisNote = lua_touserdata(L, -1);
            lua_pop(L,1);
            if (thisNote) {
                thisNote->delivered = YES;
                NSLog(@"   set delivered state");
            } else {
                NSLog(@"   userdata NULL");
            }
        } else {
            NSLog(@"   no tagged handler -- not ours?");
        }
    }

// User clicked on notification...
- (void)userNotificationCenter:(NSUserNotificationCenter *)center
    didActivateNotification:(NSUserNotification *)notification {
        NSLog(@"in didActivateNotification");
        NSNumber* value = [[notification userInfo] objectForKey:@"handler"];
        NSLog(@"   value = %@", value);
        if (value) {
            if ([self.ActiveCallbacks objectForKey:value]) {
                if (value) {
                    int myHandle = [value intValue];
                    NSLog(@"   myHandle = %d", myHandle);
                    lua_State* L = self.L;
                    lua_rawgeti(L, LUA_REGISTRYINDEX, (int)myHandle);
                    notification_t* thisNote = lua_touserdata(L, -1);
                    lua_pop(L,1);
                    if (thisNote) {
                        NSLog(@"   exec callback");
                        lua_rawgeti(L, LUA_REGISTRYINDEX, thisNote->fn);
                        lua_call(L, 0, 0);
                    } else {
                        NSLog(@"   userdata NULL");
                    }
                }
            } else {
                NSLog(@"   handler not Active");
            }
        } else {
            NSLog(@"   no tagged handler -- passing along");
            [old_delegate userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:notification];
        }
    }

// Should notification show, even if we're the foremost application?
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
    shouldPresentNotification:(NSUserNotification *)notification {
        NSLog(@"in shouldPresentNotification");
        return YES;
    }
@end

static int notification_delegate_setup(lua_State* L) {
    old_delegate = [[NSUserNotificationCenter defaultUserNotificationCenter] delegate];
    NSLog(@"old_delegate = %@", old_delegate);
    if (!old_delegate) {
        [MJUserNotificationManager sharedManager];
        old_delegate = [[NSUserNotificationCenter defaultUserNotificationCenter] delegate];
        NSLog(@"old_delegate = %@", old_delegate);
    }
    notification_delegate = [noteDelegate sharedManagerForLua:L];
    return 0;
}

// End of delegate definition

// mjolnir._asm.ui.notification.new(title, subtitle, information, fn) -> notification
// Constructor
// Returns a new notification object with the specified information and the assigned callback function.
static int notification_new(lua_State* L) {
    NSLog(@"notification_new");
    NSString* title         = [NSString stringWithUTF8String: luaL_checkstring(L, 1)];
    NSString* subtitle      = [NSString stringWithUTF8String: luaL_checkstring(L, 2)];
    NSString* information   = [NSString stringWithUTF8String: luaL_checkstring(L, 3)];
    luaL_checktype(L, 4, LUA_TFUNCTION);
    lua_pushvalue(L, 4);
    int theFunction = luaL_ref(L, LUA_REGISTRYINDEX);

    notification_t* notification = lua_newuserdata(L, sizeof(notification_t)) ;
    memset(notification, 0, sizeof(notification_t)) ;
    notification->delivered = NO;
    notification->fn        = theFunction ;
    notification->registryHandle = store_udhandler(L, notificationHandlers, -1);

    NSUserNotification* note = [[NSUserNotification alloc] init];
    note.title              = title;
    note.subtitle           = subtitle;
    note.informativeText    = information;
    note.userInfo           = @{@"handler": [NSNumber numberWithInt: notification->registryHandle]};
    NSLog(@"   handle = %d", notification->registryHandle);

    notification->note = (__bridge_retained NSUserNotification*)note;

    luaL_getmetatable(L, USERDATA_TAG);
    lua_setmetatable(L, -2);

    return 1;
}

/// mjolnir._asm.ui.notification:show() -> self
/// Method
/// Delivers the notification to the Notification Center.  If a notification has been modified, then this will resend it, setting the delivered status again.  You can invoke this multiple times if you wish to repeat the same notification.
static int notification_show(lua_State* L) {
    NSLog(@"notification_show");
    notification_t* notification = luaL_checkudata(L, 1, USERDATA_TAG);
    lua_settop(L,1);
    [[noteDelegate sharedManagerForLua:L] sendNotification:(NSUserNotification*)notification->note];
    return 1;
}

/// mjolnir._asm.ui.notification:release() -> self
/// Method
/// Disables the callback function for a notification.  Is also invoked during garbage collection (or a mjolnir.reload()).
static int notification_release(lua_State* L) {
    NSLog(@"notification_release");
    notification_t* notification = luaL_checkudata(L, 1, USERDATA_TAG);
    lua_settop(L,1);
    [[noteDelegate sharedManagerForLua:L] releaseNotification:(NSUserNotification*)notification->note];
    luaL_unref(L, LUA_REGISTRYINDEX, notification->fn);
    remove_udhandler(L, notificationHandlers, notification->registryHandle);
    return 1;
}

/// mjolnir._asm.ui.notification:withdraw() -> self
/// Method
/// Withdraws a delivered notification from the Notification Center.  Note that if you modify a delivered note, even with `release`, then it is no longer considered delivered and this method will do nothing.  If you want to fully remove a notification, invoke this method and then invoke `release`, not the other way around.
static int notification_withdraw(lua_State* L) {
    NSLog(@"notification_withdraw");
    notification_t* notification = luaL_checkudata(L, 1, USERDATA_TAG);
    lua_settop(L,1);
    [[noteDelegate sharedManagerForLua:L] withdrawNotification:(NSUserNotification*)notification->note];
//    lua_pushcfunction(L, notification_release) ; lua_pushvalue(L,1); lua_call(L, 1, 1);
    return 1;
}

static int notification_gc(lua_State* L) {
    NSLog(@"notification_gc");
    notification_t* notification = luaL_checkudata(L, 1, USERDATA_TAG);

    lua_pushcfunction(L, notification_release) ; lua_pushvalue(L,1); lua_call(L, 1, 1);

    return 0;
}


static int meta_gc(lua_State* L) {
    NSLog(@"meta_gc");
    [notificationHandlers release];
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:(id <NSUserNotificationCenterDelegate>)old_delegate];
    return 0;
}

// Metatable for created objects when _new invoked
static const luaL_Reg notification_metalib[] = {
    {"show",        notification_show},         // Add to notification center
    {"release",     notification_release},      // Leave in notification center, but detach callback
    {"withdraw",    notification_withdraw},     // Remove from the notification center
    {"__gc",        notification_gc},           // hopefully same as release + release handler
    {NULL,      NULL}
};

// Functions for returned object when module loads
static const luaL_Reg notificationLib[] = {
    {"_new",     notification_new},
// show will be a lua wrapper with a module function providing backwards compatibility with lookup function for tag
    {NULL,      NULL}
};

// Metatable for returned object when module loads
static const luaL_Reg meta_gcLib[] = {
    {"__gc",    meta_gc},
    {NULL,      NULL}
};

int luaopen_mjolnir__asm_ui_notification_internal(lua_State* L) {
    notification_delegate_setup(L);

// Metatable for created objects
    luaL_newlib(L, notification_metalib);
        lua_pushvalue(L, -1);
        lua_setfield(L, -2, "__index");
        lua_setfield(L, LUA_REGISTRYINDEX, USERDATA_TAG);

// Create table for luaopen
    luaL_newlib(L, notificationLib);
        luaL_newlib(L, meta_gcLib);
        lua_setmetatable(L, -2);

    return 1;
}

// a = rq("ui.notification").new("1","2","3",function() print("whee!") end)