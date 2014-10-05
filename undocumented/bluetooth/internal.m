#import <Foundation/Foundation.h>
#import <lauxlib.h>

// private methods
int IOBluetoothPreferencesAvailable();

int IOBluetoothPreferenceGetControllerPowerState();
void IOBluetoothPreferenceSetControllerPowerState(int state);

int IOBluetoothPreferenceGetDiscoverableState();
void IOBluetoothPreferenceSetDiscoverableState(int state);

/// mjolnir._asm.undocumented.bluetooth.available() -> bool
/// Function
/// Returns true or false, indicating whether bluetooth is available on this machine.
static int bt_available(lua_State* L) {
    if (IOBluetoothPreferencesAvailable())
        lua_pushboolean(L, YES) ;
    else
        lua_pushboolean(L, NO) ;
    return 1;
}

/// mjolnir._asm.undocumented.bluetooth.power() -> bool
/// Function
/// Returns true or false, indicating whether bluetooth is enabled for this machine.
static int bt_power(lua_State* L) {
    if (IOBluetoothPreferenceGetControllerPowerState())
        lua_pushboolean(L, YES) ;
    else
        lua_pushboolean(L, NO) ;
    return 1;
}

/// mjolnir._asm.undocumented.bluetooth.discoverable() -> bool
/// Function
/// Returns true or false, indicating whether this machine is currently discoverable via bluetooth.
static int bt_discoverable(lua_State* L) {
    if (IOBluetoothPreferenceGetDiscoverableState())
        lua_pushboolean(L, YES) ;
    else
        lua_pushboolean(L, NO) ;
    return 1;
}

/// mjolnir._asm.undocumented.bluetooth.set_power(bool)
/// Function
/// Set bluetooth power state to on (true) or off (false).
static int bt_set_power(lua_State* L) {
    IOBluetoothPreferenceSetControllerPowerState((Boolean) lua_toboolean(L, -1));
    usleep(1000000); // Apparently it doesn't like being re-queried too quickly
    return 0;
}

/// mjolnir._asm.undocumented.bluetooth.set_discoverable(bool)
/// Function
/// Set bluetooth discoverable state to on (true) or off (false).
static int bt_set_discoverable(lua_State* L) {
    IOBluetoothPreferenceSetDiscoverableState((Boolean) lua_toboolean(L, -1));
    usleep(1000000);  // Apparently it doesn't like being re-queried too quickly
    return 0;
}

static const luaL_Reg bluetoothLib[] = {
    {"available",           bt_available},
    {"power",               bt_power},
    {"discoverable",        bt_discoverable},
    {"set_power",           bt_set_power},
    {"set_discoverable",    bt_set_discoverable},
    {NULL, NULL}
};

int luaopen_mjolnir__asm_undocumented_bluetooth_internal(lua_State* L) {
    luaL_newlib(L, bluetoothLib);
    return 1;
}
