#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import <lauxlib.h>

// Not sure I'm doing memory release properly, as sounds and sound names can
// persist through a reload, so, for now, leave it in GC and get back to it...

//void NSLog(NSString* format, ...) {}
#define USERDATA_TAG    "mjolnir._asm.ui.sound"

@interface soundDelegate : NSObject <NSSoundDelegate>
@property lua_State* L;
@property int fn;
@end

@implementation soundDelegate
- (void) sound:(NSSound *)sound didFinishPlaying:(BOOL)playbackSuccessful
{
    lua_State* L = self.L;
    lua_rawgeti(L, LUA_REGISTRYINDEX, self.fn);
    lua_pushboolean(L, playbackSuccessful);
    lua_call(L, 1, 0);
}
@end

// Common Code

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

static NSMutableIndexSet* soundHandlers;

typedef struct _sound_t{
    NSSound*            soundObject;
    bool                stopOnRelease;
    soundDelegate*      callback;
    int                 fn;
    int                 registryHandle;
} sound_t;

// Not so common code

/// mjolnir._asm.ui.sound.get_byname(string) -> sound
/// Function
/// Attempts to locate and load a named sound.  By default, the only named sounds are the System Sounds (found in ~/Library/Sounds, /Library/Sounds, /Network/Library/Sounds, and /System/Library/Sounds. You can also name sounds you've previously loaded with this module and this name will persist as long as Mjolnir is running.  If the name specified cannot be found, this function returns `nil`.
static int sound_byname(lua_State* L) {
    NSSound* theSound = [[NSSound soundNamed:[NSString stringWithUTF8String: luaL_checkstring(L, 1)]] retain] ;
    if (theSound) {
        sound_t* soundUserData = lua_newuserdata(L, sizeof(sound_t)) ;
        memset(soundUserData, 0, sizeof(sound_t)) ;
        soundUserData->soundObject = theSound ;
        soundUserData->stopOnRelease = YES;
        soundUserData->callback = nil;
        soundUserData->fn = 0;
        soundUserData->registryHandle = store_udhandler(L, soundHandlers, -1) ;
        luaL_getmetatable(L, USERDATA_TAG);
        lua_setmetatable(L, -2);
    } else {
        lua_pushnil(L) ;
    }
    return 1;
}

/// mjolnir._asm.ui.sound.get_byfile(string) -> sound
/// Function
/// Attempts to locate and load the sound file at the location specified and return an NSSound object for the sound file.  Returns `nil` if it is unable to load the file.
static int sound_byfile(lua_State* L) {
    NSSound* theSound = [[[NSSound alloc] initWithContentsOfFile:[NSString stringWithUTF8String: luaL_checkstring(L, 1)] byReference: NO] retain] ;
    if (theSound) {
        sound_t* soundUserData = lua_newuserdata(L, sizeof(sound_t)) ;
        memset(soundUserData, 0, sizeof(sound_t)) ;
        soundUserData->soundObject = theSound ;
        soundUserData->stopOnRelease = YES;
        soundUserData->callback = nil;
        soundUserData->fn = 0;
        soundUserData->registryHandle = store_udhandler(L, soundHandlers, -1) ;
        luaL_getmetatable(L, USERDATA_TAG);
        lua_setmetatable(L, -2);
    } else {
        lua_pushnil(L) ;
    }
    return 1;
}

/// mjolnir._asm.ui.sound:play() -> bool
/// Method
/// Attempts to play the loaded sound and return control to Mjolnir.  Returns true or false indicating success or failure.
static int sound_play(lua_State* L) {
    sound_t* sound = luaL_checkudata(L, 1, USERDATA_TAG);
    lua_pushboolean(L, [sound->soundObject play]);
    return 1;
}

// static int sound_isPlaying(lua_State* L) {
//     sound_t* sound = luaL_checkudata(L, 1, USERDATA_TAG);
//     lua_pushboolean(L, [sound->soundObject isPLaying]);
//     return 1;
// }

/// mjolnir._asm.ui.sound:pause() -> bool
/// Method
/// Attempts to pause the loaded sound.  Returns true or false indicating success or failure.
static int sound_pause(lua_State* L) {
    sound_t* sound = luaL_checkudata(L, 1, USERDATA_TAG);
    lua_pushboolean(L, [sound->soundObject pause]);
    return 1;
}

/// mjolnir._asm.ui.sound:resume() -> bool
/// Method
/// Attempts to resume a paused sound.  Returns true or false indicating success or failure.
static int sound_resume(lua_State* L) {
    sound_t* sound = luaL_checkudata(L, 1, USERDATA_TAG);
    lua_pushboolean(L, [sound->soundObject resume]);
    return 1;
}

/// mjolnir._asm.ui.sound:stop() -> bool
/// Method
/// Attempts to stop a playing sound.  Returns true or false indicating success or failure.
static int sound_stop(lua_State* L) {
    sound_t* sound = luaL_checkudata(L, 1, USERDATA_TAG);
    lua_pushboolean(L, [sound->soundObject stop]);
    return 1;
}

/// mjolnir._asm.ui.sound:loopSound([bool]) -> bool
/// Attribute
/// If a boolean argument is provided it is used to set whether the sound will loop upon completion.  Returns the current status of this attribute.  Note that if a sound is looped, it will not call the callback function (if defined) upon completion of playback.
static int sound_loopSound(lua_State* L) {
    sound_t* sound = luaL_checkudata(L, 1, USERDATA_TAG);
    if (!lua_isnone(L, 2)) {
        [sound->soundObject setLoops:lua_toboolean(L, 2)];
    }
    lua_pushboolean(L, [sound->soundObject loops]);
    return 1;
}

/// mjolnir._asm.ui.sound:stopOnRelease([bool]) -> bool
/// Attribute
/// If a boolean argument is provided it is used to set whether the sound will be stopped when released (when Mjolnir is reloaded or `release` is called).  Returns the current status of this attribute.  Defaults to `true`.  This can only be changed if you've assigned a name to the sound; otherwise, it becomes possible to have a sound you can't access running in the background.
static int sound_stopOnRelease(lua_State* L) {
    sound_t* sound = luaL_checkudata(L, 1, USERDATA_TAG);
    if (!lua_isnone(L, 2)) {
        if ([sound->soundObject name]) {
            sound->stopOnRelease = lua_toboolean(L, 2);
        } else {
            lua_pushstring(L, "you must first assign a name to this sound in order to change this attribute");
            lua_error(L);
        }
    }
    lua_pushboolean(L, sound->stopOnRelease);
    return 1;
}

/// mjolnir._asm.ui.sound:name([string]) -> string
/// Attribute
/// If a string argument is provided it is used to set name the sound. Returns the current name, if defined.  This name can be used to reselect a sound with `get_byname` as long as Mjolnir has not been exited since the sound was named.  Returns `nil` if no name has been assigned.
static int sound_name(lua_State* L) {
    sound_t* sound = luaL_checkudata(L, 1, USERDATA_TAG);
    if (!lua_isnone(L, 2)) {
        if (lua_isnil(L,2)) {
            [sound->soundObject setName:nil];
            sound->stopOnRelease = YES;
        } else {
            [sound->soundObject setName:[NSString stringWithUTF8String: luaL_checkstring(L, 2)]];
        }
    }
    lua_pushstring(L, [[sound->soundObject name] UTF8String]);
    return 1;
}

/// mjolnir._asm.ui.sound:device([string]) -> string
/// Attribute
/// If a string argument is provided it is used to set name the playback device for the sound. Returns the current name, if defined or nil if it hasn't been changed from the System default.  Note that this name is not the same as the name returned by the `name` method of `mjolnir._asm.sys.audiodevice`.  Make sure you're using version 0.2-1 or later of `mjolnir._asm.sys.audiodevice` and use the `uid` method to get the proper device names for this method.  Setting this to `nil` will use the system default device.
static int sound_device(lua_State* L) {
    sound_t* sound = luaL_checkudata(L, 1, USERDATA_TAG);
    if (!lua_isnone(L, 2)) {
        if (lua_isnil(L,2)) {
            [sound->soundObject setPlaybackDeviceIdentifier:nil];
        } else {
            @try {
                [sound->soundObject setPlaybackDeviceIdentifier:[NSString stringWithUTF8String: luaL_checkstring(L, 2)]];
            } @catch(NSException *theException) {
                NSLog(@"%s:device -- %@: %@", USERDATA_TAG, theException.name, theException.reason);
                lua_pushstring(L, [[NSString stringWithFormat:@"%@: %@", theException.name, theException.reason] UTF8String]);
                lua_error(L);
            }
        }
    }
    lua_pushstring(L, [[sound->soundObject playbackDeviceIdentifier] UTF8String]);
    return 1;
}

/// mjolnir._asm.ui.sound:currentTime([seconds]) -> seconds
/// Attribute
/// If a number argument is provided it is used to set the playback location to the number of seconds specified.  Returns the current position in seconds.
static int sound_currentTime(lua_State* L) {
    sound_t* sound = luaL_checkudata(L, 1, USERDATA_TAG);
    if (!lua_isnone(L, 2)) {
        [sound->soundObject setCurrentTime:luaL_checknumber(L, 2)];
    }
    lua_pushnumber(L, [sound->soundObject currentTime]);
    return 1;
}

/// mjolnir._asm.ui.sound:duration() -> seconds
/// Attribute
/// Returns the duration of the sound in seconds.
static int sound_duration(lua_State* L) {
    sound_t* sound = luaL_checkudata(L, 1, USERDATA_TAG);
    lua_pushnumber(L, [sound->soundObject duration]);
    return 1;
}

/// mjolnir._asm.ui.sound:volume([number]) -> number
/// Attribute
/// If a number argument is provided it is used to set the playback volume relative to the system volume.  Returns the current playback volume relative to the current system volume.  The number will be between 0.0 and 1.0.
static int sound_volume(lua_State* L) {
    sound_t* sound = luaL_checkudata(L, 1, USERDATA_TAG);
    if (!lua_isnone(L, 2)) {
        [sound->soundObject setVolume:luaL_checknumber(L, 2)];
    }
    lua_pushnumber(L, [sound->soundObject volume]);
    return 1;
}

/// mjolnir._asm.ui.sound:function([fn|nil]) -> bool
/// Attribute
/// If no argument is provided, returns whether or not the sound has an assigned callback function to invoke when the sound playback has completed.  If you provide a function as the argument, this function will be invoked when playback completes with an argument indicating whether playback ended normally (at the end of the song, for example) or if ended abnormally (stopped via the `stop` method).  If `nil` is provided, then any existing callback function will be removed.  This is called with `nil` during garbage collection (during a reload of Mjolnir) to prevent invoking a callback that no longer exists if playback isn't stopped at reload.
static int sound_callback(lua_State* L) {
    sound_t* sound = luaL_checkudata(L, 1, USERDATA_TAG);
    if (!lua_isnone(L, 2)) {
        if (lua_isnil(L,2)) {
            if (sound->fn) {
                luaL_unref(L, LUA_REGISTRYINDEX, sound->fn);
                sound->fn = 0 ;
            }
            if (sound->callback) {
                [[sound->soundObject delegate] release];
                [sound->soundObject setDelegate:nil];
                sound->callback = nil ;
            }
        } else {
            luaL_checktype(L, 2, LUA_TFUNCTION);
            lua_pushvalue(L, 2);
            sound->fn = luaL_ref(L, LUA_REGISTRYINDEX);
            soundDelegate* object = [[soundDelegate alloc] init];
            object.L = L;
            object.fn = sound->fn;
            sound->callback = (__bridge_retained void*)object;
            [sound->soundObject setDelegate: object];
        }
    }
    if (sound->callback) {
        lua_pushboolean(L, YES);
    } else {
        lua_pushboolean(L, NO);
    }
    return 1;
}

/// mjolnir._asm.ui.sound.soundTypes() -> array
/// Function
/// Returns an array of the UTI formats supported by this module for sound playback.
static int sound_soundUnfilteredTypes(lua_State* L) {
    int i = 0;
    NSArray* list = [NSSound soundUnfilteredTypes];
    lua_newtable(L);
    for (id item in list) {
        lua_pushstring(L, [item UTF8String]);
        lua_rawseti(L, -2, ++i);
    }
    return 1;
}

/// mjolnir._asm.ui.sound.soundFileTypes() -> array
/// Function
/// Returns an array of the file extensions for file types supported by this module for sound playback.  Note that this uses a method which has been deprecated since 10.5, so while it apparently sticks around, it may be removed in the future. The preferred method is to use the UTI values returned via `mjolnir._asm.ui.sound.soundTypes` for determination.
static int sound_soundUnfilteredFileTypes(lua_State* L) {
    int i = 0;
    NSArray* list = [NSSound soundUnfilteredFileTypes];
    lua_newtable(L);
    for (id item in list) {
        lua_pushstring(L, [item UTF8String]);
        lua_rawseti(L, -2, ++i);
    }
    return 1;
//    NSObject_to_lua(L, [NSSound soundUnfilteredFileTypes]);
//    return 1;
}

// /// mjolnir._asm.ui.sound:release() -> sound
// /// Method
// /// Releases a sound.  Any callback function is removed, and if the `stopOnRelease` is true, sound playback will be stopped.
static int sound_release(lua_State* L) {
    sound_t* sound = luaL_checkudata(L, 1, USERDATA_TAG);
    lua_settop(L,1);
    lua_pushcfunction(L, sound_callback) ;
    lua_pushvalue(L,1);
    lua_pushnil(L);
    lua_call(L, 2, 1);
    if (sound->stopOnRelease) [sound->soundObject stop];
    remove_udhandler(L, soundHandlers, sound->registryHandle);
    return 1;
}

// Common wrap-up

static int sound_setup(lua_State* L) {
    if (!soundHandlers) soundHandlers = [[NSMutableIndexSet indexSet] retain];
    return 0;
}

static int sound_gc(lua_State* L) {
    sound_t* sound = luaL_checkudata(L, 1, USERDATA_TAG);
    lua_pushcfunction(L, sound_release) ; lua_pushvalue(L,1); lua_call(L, 1, 1);
    [sound->soundObject release];
    sound->soundObject = nil;
    return 0;
}

static int meta_gc(lua_State* L) {
    [soundHandlers release];
    soundHandlers = nil;
    return 0;
}

// Metatable for created objects when _new invoked
static const luaL_Reg sound_metalib[] = {
    {"play",            sound_play},
    {"pause",           sound_pause},
    {"resume",          sound_resume},
    {"stop",            sound_stop},
    {"loopSound",       sound_loopSound},
    {"name",            sound_name},
    {"volume",          sound_volume},
    {"currentTime",     sound_currentTime},
    {"duration",        sound_duration},
    {"device",          sound_device},
    {"stopOnRelease",   sound_stopOnRelease},
    {"callback",        sound_callback},
//    {"isPlaying",       sound_isPlaying}, // Not in 10.10... can we replicate another way?
//    {"release",         sound_release},
    {"__gc",	        sound_gc},
    {NULL,              NULL}
};

// Functions for returned object when module loads
static const luaL_Reg soundLib[] = {
    {"soundTypes",      sound_soundUnfilteredTypes},
    {"soundFileTypes",  sound_soundUnfilteredFileTypes},
    {"get_byname",      sound_byname},
    {"get_byfile",      sound_byfile},
    {NULL,              NULL}
};

// Metatable for returned object when module loads
static const luaL_Reg meta_gcLib[] = {
    {"__gc",    meta_gc},
    {NULL,      NULL}
};

int luaopen_mjolnir__asm_ui_sound_internal(lua_State* L) {
    sound_setup(L);

// Metatable for created objects
    luaL_newlib(L, sound_metalib);
        lua_pushvalue(L, -1);
        lua_setfield(L, -2, "__index");
        lua_setfield(L, LUA_REGISTRYINDEX, USERDATA_TAG);

// Create table for luaopen
    luaL_newlib(L, soundLib);

        luaL_newlib(L, meta_gcLib);
        lua_setmetatable(L, -2);

    return 1;
}
