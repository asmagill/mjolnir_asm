#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import <lauxlib.h>
#import <IOKit/ps/IOPowerSources.h>
#import <IOKit/ps/IOPSKeys.h>
#import <IOKit/pwr_mgt/IOPM.h>
#import <IOKit/pwr_mgt/IOPMLib.h>
#import <dlfcn.h>

static void*        _asmLib ;

static void* link_extlib(lua_State* L, NSString *Name) {
    const char* cmdLine = [
        [[NSString alloc]
            initWithFormat:@"return package.searchpath(\"%@\",package.cpath)", Name]
        UTF8String
    ];
    int error = luaL_loadbuffer(L, cmdLine, strlen(cmdLine), "internal") || lua_pcall(L, 0, 1, 0);
    if (error) { lua_error(L); }
    void* ourLib = dlopen(luaL_checkstring(L, -1), RTLD_LAZY);
    lua_pop(L, 1);
    if (!ourLib) { lua_pushstring(L, dlerror()); lua_error(L); }
    return ourLib;
}

// Define wrappers for the functions from the external library that we want:

static void NSObject_to_lua(lua_State* L, id obj) {
    void (*f)() = dlsym(_asmLib, "NSObject_to_lua"); return (*f)(L, obj);
}


// Gets battery info from IOPM API.
NSDictionary* get_iopm_battery_info() {
    mach_port_t masterPort;
    CFArrayRef batteryInfo;

    if (kIOReturnSuccess == IOMasterPort(MACH_PORT_NULL, &masterPort) &&
        kIOReturnSuccess == IOPMCopyBatteryInfo(masterPort, &batteryInfo) &&
        CFArrayGetCount(batteryInfo))
    {
        CFDictionaryRef battery = CFDictionaryCreateCopy(NULL, CFArrayGetValueAtIndex(batteryInfo, 0));
        CFRelease(batteryInfo);
        return (__bridge_transfer NSDictionary*) battery;
    }
    return NULL;
}

// Get battery info from IOPS API.
NSDictionary* get_iops_battery_info() {
    CFTypeRef info = IOPSCopyPowerSourcesInfo();

    if (info == NULL)
        return NULL;


    CFArrayRef list = IOPSCopyPowerSourcesList(info);

    // Nothing we care about here...
    if (list == NULL || !CFArrayGetCount(list)) {
        if (list)
            CFRelease(list);

        CFRelease(info);
        return NULL;
    }

    CFDictionaryRef battery = CFDictionaryCreateCopy(NULL, IOPSGetPowerSourceDescription(info, CFArrayGetValueAtIndex(list, 0)));

    // Battery is released by ARC transfer.
    CFRelease(list);
    CFRelease(info);

    return (__bridge_transfer NSDictionary* ) battery;
}

// Get battery info from IOPMPS Apple Smart Battery API.
NSDictionary* get_iopmps_battery_info() {
    io_registry_entry_t entry = 0;
    entry = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceNameMatching("AppleSmartBattery"));
    if (entry == IO_OBJECT_NULL)
        return nil;

    CFMutableDictionaryRef battery;
    IORegistryEntryCreateCFProperties(entry, &battery, NULL, 0);
    return (__bridge_transfer NSDictionary *) battery;
}

// Helper function to yank an object from a dictionary by key, and push it onto the LUA stack.
static int _push_dict_key_value(lua_State* L, NSDictionary* dict, NSString* key) {
    id value = [dict objectForKey:key];
    NSObject_to_lua(L, value);
    return 1;
}

/// mjolnir._asm.sys.battery.cycles() -> number
/// Function
/// Returns the number of cycles the connected battery has went through.
static int battery_cycles(lua_State *L) {
    return _push_dict_key_value(L, get_iopm_battery_info(), @kIOBatteryCycleCountKey);
}

/// mjolnir._asm.sys.battery.name() -> string
/// Function
/// Returns the name of the battery.
static int battery_name(lua_State *L) {
    return _push_dict_key_value(L, get_iops_battery_info(), @kIOPSNameKey);
}

/// mjolnir._asm.sys.battery.maxcapacity() -> number
/// Function
/// Returns the current maximum capacity of the battery in mAh.
static int battery_maxcapacity(lua_State *L) {
    return _push_dict_key_value(L, get_iopm_battery_info(), @kIOBatteryCapacityKey);
}

/// mjolnir._asm.sys.battery.capacity() -> number
/// Function
/// Returns the current capacity of the battery in mAh.
static int battery_capacity(lua_State *L) {
    return _push_dict_key_value(L, get_iopm_battery_info(), @kIOBatteryCurrentChargeKey);
}

/// mjolnir._asm.sys.battery.designcapacity() -> number
/// Function
/// Returns the design capacity of the battery in mAh.
static int battery_designcapacity(lua_State *L) {
    return _push_dict_key_value(L, get_iopmps_battery_info(), @kIOPMPSDesignCapacityKey);
}

/// mjolnir._asm.sys.battery.voltage() -> number
/// Function
/// Returns the voltage flow of the battery in mV.
static int battery_voltage(lua_State *L) {
    return _push_dict_key_value(L, get_iopm_battery_info(), @kIOBatteryVoltageKey);
}

/// mjolnir._asm.sys.battery.amperage() -> number
/// Function
/// Returns the amperage of the battery in mA. (will be negative if battery is discharging)
static int battery_amperage(lua_State *L) {
    return _push_dict_key_value(L, get_iopm_battery_info(), @kIOBatteryAmperageKey);
}

/// mjolnir._asm.sys.battery.watts() -> number
/// Function
/// Returns the watts into or out of the battery in Watt (will be negative if battery is discharging)
static int battery_watts(lua_State *L) {
    NSDictionary* battery = get_iopm_battery_info();

    NSNumber *amperage = [battery objectForKey:@kIOBatteryVoltageKey];
    NSNumber *voltage = [battery objectForKey:@kIOBatteryAmperageKey];

    if (amperage && voltage) {
        double battery_wattage = ([amperage doubleValue] * [voltage doubleValue]) / 1000000;
        lua_pushnumber(L, battery_wattage);
    } else
        lua_pushnil(L);

    return 1;
}

/// mjolnir._asm.sys.battery.health() -> string
/// Function
/// Returns the health status of the battery. One of {Good, Fair, Poor}
static int battery_health(lua_State *L) {
    return _push_dict_key_value(L, get_iops_battery_info(), @kIOPSBatteryHealthKey);
}

/// mjolnir._asm.sys.battery.healthcondition() -> string
/// Function
/// Returns the health condition status of the battery. One of {Check Battery, Permanent Battery Failure}. Nil if there is no health condition set.
static int battery_healthcondition(lua_State *L) {
    return _push_dict_key_value(L, get_iops_battery_info(), @kIOPSBatteryHealthConditionKey);
}

/// mjolnir._asm.sys.battery.percentage() -> number
/// Function
/// Returns the current percentage of the battery between 0 and 100.
static int battery_percentage(lua_State *L) {
    NSDictionary* battery = get_iops_battery_info();

    // IOPS Gives the proper percentage reading, that the OS displays...
    // IOPM... oddly enough... is a few percentage points off.
    NSNumber *maxCapacity = [battery objectForKey:@kIOPSMaxCapacityKey];
    NSNumber *currentCapacity = [battery objectForKey:@kIOPSCurrentCapacityKey];

    if (maxCapacity && currentCapacity) {
        double battery_percentage = ([currentCapacity doubleValue] / [maxCapacity doubleValue]) * 100;
        lua_pushnumber(L, battery_percentage);
    } else
        lua_pushnil(L);

    return 1;
}

/// mjolnir._asm.sys.battery.timeremaining() -> number
/// Function
/// Returns the time remaining in minutes. Or a negative value: -1 = calculating time remaining, -2 = unlimited (i.e. you're charging, or apple has somehow discovered an infinite power source.)

static int battery_timeremaining(lua_State* L) {
    CFTimeInterval remaining = IOPSGetTimeRemainingEstimate();

    if (remaining > 0)
        remaining /= 60;

    lua_pushnumber(L, remaining);
    return 1;
}

/// mjolnir._asm.sys.battery.timetofullcharge() -> number
/// Function
/// Returns the time remaining to a full charge in minutes. Or a negative value, -1 = calculating time remaining.
static int battery_timetofullcharge(lua_State* L) {
    return _push_dict_key_value(L, get_iops_battery_info(), @kIOPSTimeToFullChargeKey);
}

/// mjolnir._asm.sys.battery.ischarging() -> boolean
/// Function
/// Returns true if the battery is charging.
static int battery_ischarging(lua_State* L) {
    return _push_dict_key_value(L, get_iops_battery_info(), @kIOPSIsChargingKey);
}

/// mjolnir._asm.sys.battery.ischarged() -> boolean
/// Function
/// Returns true if battery is charged.
static int battery_ischarged(lua_State* L) {
    return _push_dict_key_value(L, get_iops_battery_info(), @kIOPSIsChargedKey);
}

/// mjolnir._asm.sys.battery.isfinishingcharge() -> boolean
/// Function
/// Returns true if battery is finishing charge.
static int battery_isfinishingcharge(lua_State* L) {
    return _push_dict_key_value(L, get_iops_battery_info(), @kIOPSIsFinishingChargeKey);
}

/// mjolnir._asm.sys.battery.powersource() -> boolean
/// Function
/// Returns current source of power. One of {AC Power, Battery Power, Off Line}.
static int battery_powersource(lua_State* L) {
    return _push_dict_key_value(L, get_iops_battery_info(), @kIOPSPowerSourceStateKey);
}


static luaL_Reg batteryLib[] = {
    {"cycles", battery_cycles},
    {"name", battery_name},
    {"maxcapacity", battery_maxcapacity},
    {"capacity", battery_capacity},
    {"designcapacity", battery_designcapacity},
    {"percentage", battery_percentage},
    {"voltage", battery_voltage},
    {"amperage", battery_amperage},
    {"watts", battery_watts},
    {"health", battery_health},
    {"healthcondition", battery_healthcondition},
    {"timeremaining", battery_timeremaining},
    {"timetofullcharge", battery_timetofullcharge},
    {"ischarging", battery_ischarging},
    {"ischarged", battery_ischarged},
    {"isfinishingcharge", battery_isfinishingcharge},
    {"powersource", battery_powersource},
    {NULL, NULL}
};

// Release shared library upon collection of this module
static int meta_gc(lua_State* L) {
    if (_asmLib) { dlclose(_asmLib); }
    return 0;
}
// Metatable for returned object when module loads
static const luaL_Reg meta_gcLib[] = {
    {"__gc",    meta_gc},
    {NULL,      NULL}
};

int luaopen_mjolnir__asm_sys_battery_internal(lua_State* L) {
    // link to external library, mjolnir._asm.internal.so
    _asmLib = link_extlib(L, @"mjolnir._asm.internal") ;

    // setup the module
    luaL_newlib(L, batteryLib);
        luaL_newlib(L, meta_gcLib);
        lua_setmetatable(L, -2);

    return 1;
}
