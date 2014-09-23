#import <Cocoa/Cocoa.h>
#import <lauxlib.h>

/// mjolnir._asm.hydra.showabout()
/// Function
/// Displays the standard OS X about panel; implicitly focuses Mjolnir.
static int mjolnir_showabout(lua_State* L) {
    [NSApp activateIgnoringOtherApps:YES];
    [NSApp orderFrontStandardAboutPanel:nil];
    return 0;
}

/// mjolnir._asm.hydra.fileexists(path) -> exists, isdir
/// Function
/// Checks if a file exists, and whether it's a directory.
static int mjolnir_fileexists(lua_State* L) {
    NSString* path = [NSString stringWithUTF8String:luaL_checkstring(L, 1)];

    BOOL isdir;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isdir];

    lua_pushboolean(L, exists);
    lua_pushboolean(L, isdir);
    return 2;
}

/// mjolnir._asm.hydra._version() -> number
/// Function
/// Return the current Mjolnir version as a string.
static int mjolnir_version(lua_State* L) {
    NSString* ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    lua_pushstring(L, [ver UTF8String]);
    return 1;
}

/// mjolnir._asm.hydra._paths() -> table
/// Function
/// Returns a table containing the resourcePath, the bundlePath, and the executablePath for the Mjolnir application.
static int mjolnir_paths(lua_State* L) {
    lua_newtable(L) ;
        lua_pushstring(L, [[[NSBundle mainBundle] resourcePath] fileSystemRepresentation]);
        lua_setfield(L, -2, "resourcePath");
        lua_pushstring(L, [[[NSBundle mainBundle] bundlePath] fileSystemRepresentation]);
        lua_setfield(L, -2, "bundlePath");
        lua_pushstring(L, [[[NSBundle mainBundle] executablePath] fileSystemRepresentation]);
        lua_setfield(L, -2, "executablePath");

    return 1;
}

/// mjolnir._asm.hydra.uuid() -> string
/// Function
/// Returns a newly generated UUID as a string
static int mjolnir_uuid(lua_State* L) {
    lua_pushstring(L, [[[NSUUID UUID] UUIDString] UTF8String]);
    return 1;
}

/// mjolnir._asm.hydra.check_accessibility(shouldprompt) -> isenabled
/// Function
/// Returns whether accessibility is enabled. If passed `true`, prompts the user to enable it.
static int check_accessibility(lua_State* L) {
    extern BOOL MJAccessibilityIsEnabled(void);
    extern void MJAccessibilityOpenPanel(void);

    BOOL shouldprompt = lua_toboolean(L, 1);
    BOOL enabled = MJAccessibilityIsEnabled();
    if (shouldprompt) { MJAccessibilityOpenPanel(); }
    lua_pushboolean(L, enabled);
    return 1;
}

/// mjolnir._asm.hydra.autolaunch([arg]) -> bool
/// Function
///  When argument is absent or not a boolean value, this function returns true or false indicating whether or not Mjolnir is set to launch when you first log in.  When a boolean argument is provided, it's true or false value is used to set the auto-launch status.
static int mjolnir_autolaunch(lua_State* L) {
    extern BOOL MJAutoLaunchGet(void);
    extern void MJAutoLaunchSet(BOOL opensAtLogin);

    if (lua_isboolean(L, -1)) { MJAutoLaunchSet(lua_toboolean(L, -1)); }
    lua_pushboolean(L, MJAutoLaunchGet()) ;
    return 1;

}

static luaL_Reg hydra_lib[] = {
    { "showabout",              mjolnir_showabout },
    { "fileexists",             mjolnir_fileexists },
    { "_version",               mjolnir_version },
    { "_paths",                 mjolnir_paths },
    { "uuid",                   mjolnir_uuid },
    { "check_accessibility",    check_accessibility },
    { "autolaunch",             mjolnir_autolaunch },
    {NULL, NULL}
};

int luaopen_mjolnir__asm_hydra_internal(lua_State* L) {
    luaL_newlib(L, hydra_lib);
    return 1;
}
