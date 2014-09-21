local module = {
--[=[
    _NAME        = 'mjolnir._asm.undocumented.coredock',
    _VERSION     = 'the 1st digit of Pi/0',
    _URL         = 'https://github.com/asmagill/mjolnir_asm.undocumented/coredock',
    _LICENSE     = [[ See README.md ]]
    _DESCRIPTION = [[

--- === mjolnir._asm.undocumented.coredock ===
---
--- Home: https://github.com/asmagill/mjolnir_asm.undocumented/coredock
---
--- Functions to get and set undocumented options and features within OS X.  These are undocumented features from the "private" api's for Mac OS X and are not guaranteed to work with any particular version of OS X or at all.  This code was based primarily on code samples and segments found at (https://code.google.com/p/undocumented-goodness/) and (https://code.google.com/p/iterm2/source/browse/branches/0.10.x/CGSInternal/CGSDebug.h?r=2).
---
--- This submodule provides access to CoreDock related features.  This allows you to adjust the Dock's position, pinning, hiding, magnification and animation settings.
---
--- I make no promises that these will work for you or work at all with any, past, current, or future versions of OS X.  I can confirm only that they didn't crash my machine during testing under 10.10pb2. You have been warned.
---
--- For what it's worth, under my 10.10pb2, pinning seems to be completely ignored and setting the Dock to the top orientation is also ignored, though left, right, and bottom work.

    ]],
--]=]
}

local mjolnir_mod_name = "mjolnir._asm.undocumented.coredock"
local c_library = "internal"

-- integration with C functions ------------------------------------------

if c_library then
	for i,v in pairs(require(mjolnir_mod_name.."."..c_library)) do module[i] = v end
end

-- private variables and methods -----------------------------------------

-- Public interface ------------------------------------------------------

--- mjolnir._asm.undocumented.coredock.RestartDock()
--- Function
--- This function restarts the user's Dock instance.  This is not required for any of the functionality of this module, but does come in handy if your dock gets "misplaced" when you change monitor resolution or detach an external monitor (I've seen this occasionally when the Dock is on the left or right.)
function module.RestartDock()
    os.execute("/usr/bin/killall Dock")
end

local options_reverse = {}
for i,v in pairs(module.options.orientation) do options_reverse[v] = i end
for i,v in pairs(options_reverse) do module.options.orientation[i] = v end
local options_reverse = {}
for i,v in pairs(module.options.pinning) do options_reverse[v] = i end
for i,v in pairs(options_reverse) do module.options.pinning[i] = v end
local options_reverse = {}
for i,v in pairs(module.options.effect) do options_reverse[v] = i end
for i,v in pairs(options_reverse) do module.options.effect[i] = v end

-- Return Module Object --------------------------------------------------

return module



