#import <Cocoa/Cocoa.h>
#import <lauxlib.h>

// Source: https://gist.github.com/shpakovski/1902994

// NSString *TransformStringWithFunction(NSString *string, SecTransformRef (*function)(CFTypeRef, CFErrorRef *)) {
//     NSData *inputData = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
//     SecTransformRef transformRef = function(kSecBase64Encoding, NULL);
//     SecTransformSetAttribute(transformRef, kSecTransformInputAttributeName, (CFTypeRef)inputData, NULL);
//     CFDataRef outputDataRef = SecTransformExecute(transformRef, NULL);
//     CFRelease(transformRef);
//     return [[[NSString alloc] initWithData:(NSData *)outputDataRef encoding:NSUTF8StringEncoding] autorelease];
// }

NSData *TransformDataWithFunction(NSData *inputData, SecTransformRef (*function)(CFTypeRef, CFErrorRef *)) {
    SecTransformRef transformRef = function(kSecBase64Encoding, NULL);
    SecTransformSetAttribute(transformRef, kSecTransformInputAttributeName, (CFTypeRef)inputData, NULL);
    CFDataRef outputDataRef = SecTransformExecute(transformRef, NULL);
    CFRelease(transformRef);
    return [[[NSData alloc] initWithData:(NSData *)outputDataRef] autorelease];
}


// mjolnir._asm.data.base64.encode(val) -> str
// Function
// Returns the base64 encoding of the string provided.
static int base64_encode(lua_State* L) {
    const char* data = lua_tostring(L,1) ;
    int sz = lua_rawlen(L, 1) ;
    NSData* decodedStr = [[NSData alloc] initWithBytes:data length:sz] ;

    NSData* encodedStr = TransformDataWithFunction(decodedStr, SecEncodeTransformCreate);
    lua_pushlstring(L, [encodedStr bytes], [encodedStr length]) ;
    return 1;
}

//  mjolnir._asm.data.base64.decode(str) -> val
// Function
// Returns a Lua string representing the given base64 string.
static int base64_decode(lua_State* L) {
    const char* data = lua_tostring(L,1) ;
    int sz = lua_rawlen(L, 1) ;
    NSData* encodedStr = [[NSData alloc] initWithBytes:data length:sz] ;

    NSData* decodedStr = TransformDataWithFunction(encodedStr, SecDecodeTransformCreate);
    lua_pushlstring(L, [decodedStr bytes], [decodedStr length]) ;
    return 1;
}

// Functions for returned object when module loads
static const luaL_Reg base64Lib[] = {
    {"_encode",  base64_encode},
    {"_decode",  base64_decode},
    {NULL,      NULL}
};

int luaopen_mjolnir__asm_data_base64_internal(lua_State* L) {
    luaL_newlib(L, base64Lib);

    return 1;
}

