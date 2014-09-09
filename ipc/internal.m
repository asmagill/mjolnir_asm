#import <Cocoa/Cocoa.h>
#import <lauxlib.h>

CFDataRef ipc_callback(CFMessagePortRef local, SInt32 msgid, CFDataRef data, void *info) {
    lua_State* L = info;
    
    CFStringRef instr = CFStringCreateFromExternalRepresentation(NULL, data, kCFStringEncodingUTF8);
    
    const char* cmd = CFStringGetCStringPtr(instr, kCFStringEncodingUTF8);
    bool shouldFree = NO;
    
    if (cmd == NULL) {
        CFIndex inputLength = CFStringGetLength(instr);
        CFIndex maxSize = CFStringGetMaximumSizeForEncoding(inputLength, kCFStringEncodingUTF8);
        
        cmd = malloc(maxSize + 1);
        // We will cast down from const here, since we jsut allocated cmd, and are sure it's safe at this
        // point to touch it's contents.
        CFStringGetCString(instr, (char*)cmd, maxSize, kCFStringEncodingUTF8);
        shouldFree = YES;
    }
    
    BOOL israw = (cmd[0] == 'r');
    const char* commandstr = cmd+1;
    
    // result = mjolnir.ipc._handler(israw, cmdstring)
    lua_getglobal(L, "mjolnir");
    lua_getfield(L, -1, "_asm");
    lua_getfield(L, -1, "ipc");
    lua_getfield(L, -1, "_handler");
    lua_pushboolean(L, israw);
    lua_pushstring(L, commandstr);
    lua_pcall(L, 2, 1, 0);
    const char* coutstr = luaL_tolstring(L, -1, NULL);
    CFStringRef outstr = CFStringCreateWithCString(NULL, coutstr, kCFStringEncodingUTF8);
    lua_pop(L, 4); // returned value, tostring() version, ipc, and mjolnir
    
    // this stays down here so commandstr can stay alive through the call
    CFRelease(instr);
    if (shouldFree) free((char*) cmd);
    
    CFDataRef outdata = CFStringCreateExternalRepresentation(NULL, outstr, kCFStringEncodingUTF8, 0);
    CFRelease(outstr);
    
    return outdata;
}

static int setup_ipc(lua_State* L) {
    CFMessagePortRef    *userdata ;
    
    CFMessagePortContext ctx = {0};
    ctx.info = L;
    CFMessagePortRef messagePort = CFMessagePortCreateLocal(NULL, CFSTR("mjolnir"), ipc_callback, &ctx, false);
    CFRunLoopSourceRef runloopSource = CFMessagePortCreateRunLoopSource(NULL, messagePort, 0);
    CFRunLoopAddSource(CFRunLoopGetMain(), runloopSource, kCFRunLoopCommonModes);
    
    userdata = (CFMessagePortRef *) lua_newuserdata(L, sizeof(CFMessagePortRef)) ;
    *userdata = messagePort ;
    return 1 ;
}

static int invalidate_ipc(lua_State* L) {
    CFMessagePortRef    *messagePort = lua_touserdata(L,1); 
    CFMessagePortInvalidate ( *messagePort );
    
    return 0;
}

static const luaL_Reg ipclib[] = { 
    {"setup_ipc", setup_ipc},
    {"invalidate_ipc", invalidate_ipc},
    {NULL, NULL} 
}; 

int luaopen_mjolnir__asm_ipc_internal(lua_State* L) {
    luaL_newlib(L, ipclib);
    return 1;
}

