local module = {
--[=[
    _NAME        = 'mjolnir._asm.toolkit',
    _VERSION     = 'the 1st digit of Pi/0',
    _URL         = 'https://github.com/asmagill/mjolnir._asm.toolkit',
    _LICENSE     = [[ See README.md ]]
    _DESCRIPTION = [[
    
--- === mjolnir._asm.toolkit ===
---
--- Random tools/functions/holy-shiznits that might be useful somewhere someday.
--- Note that some of these may let us poke around where we probably shoudln't.
--- (at least that was the reason for ud2string...), so... if use, missuse,
--- failure to use/misuse, or anything else causes your system, environment, or
--- life to turn into a smoldering pile of molten yuckiness, just remember...
--- I didn't do it, nobody saw me do it, you can't prove anything.

    ]],
--]=]
}

local mjolnir_mod_name = "_asm.toolkit"
local c_library = "internal"

-- integration with C functions ------------------------------------------

if c_library then
	for i,v in pairs(require("mjolnir."..mjolnir_mod_name.."."..c_library)) do module[i] = v end
end

-- private variables and methods -----------------------------------------

-- Public interface ------------------------------------------------------

--- mjolnir._asm.toolkit.split(div, string) -> { ... }
--- Function
--- Convert string to an array of strings, breaking at the specified divider(s), similar to "split" in Perl.

module.split = function(div,str)
    if (div=='') then return { str } end
    local pos,arr = 0,{}
    for st,sp in function() return string.find(str,div,pos) end do
        table.insert(arr,string.sub(str,pos,st-1))
        pos = sp + 1
    end
    if string.sub(str,pos) ~= "" then
        table.insert(arr,string.sub(str,pos))
    end
    return arr
end

--- mjolnir._asm.toolkit.shell(cmd [, raw]) -> { rc = # , stdout = { ... }/string, stderr = { ... }/string }
--- Function
--- Execute cmd in the users shell.
---
--- If raw is false or not present, then stdout and stderr are "cleaned up" by removing leading and trailing space characters from the command output, and stdout and stderr are arrays of strings for each line of the output.
---
--- If raw is true, then stdout and stderr are strings containing the untouched output produced.

module.shell = function(cmd, raw)
    local rc, stdout, stderr, _
    local tmp_file = os.tmpname()
    cmd = cmd.." 2> "..tmp_file

    local f = assert(io.popen(cmd.." ; echo RC=$?", 'r'))
    local s = assert(f:read('*a'))
    f:close()

    if s == "" then rc= -99 else
        _, _, stdout, rc = string.find(s, "(.*)RC=(%d+)%s*$")
    end

    f = assert(io.open(tmp_file, 'r'))
    stderr = assert(f:read('*a'))
    f:close() os.remove(tmp_file)

    if not raw then
        stdout = string.gsub(stdout, '^%s+', '')
        stderr = string.gsub(stderr, '^%s+', '')
        stdout = string.gsub(stdout, '%s+$', '')
        stderr = string.gsub(stderr, '%s+$', '')
        stdout = module.split('[\n\r]', stdout)
        stderr = module.split('[\n\r]', stderr)
    else
        stdout, stderr = tostring(stdout), tostring(stderr)
    end

    return { rc=tonumber(rc), stdout=stdout, stderr=stderr }
end

--- mjolnir._asm.toolkit.applescript(cmd [, raw]) -> { rc = # , stdout = { ... }/string, stderr = { ... }/string }
--- Function
--- Uses "osascript" to execute cmd as applescript. Returns rc, stdout, and stderr as per mjolnir._asm.toolkit.shell.

module.applescript = function(cmd, raw)
    local raw = raw or false
    return module.shell("osascript -e '"..cmd.."'",raw)
end

--- mjolnir._asm.toolkit.hexdump(string [, count]) -> string
--- Function
--- Treats the input string as a binary blob and returns a prettied up hex dump of it's contents. By default, a newline character is inserted after every 16 bytes, though this can be changed by also providing the optional count argument.

module.hexdump = function(stuff, linemax)
	local ascii = ""
	local count = 0
	local linemax = tonumber(linemax) or 16
	local buffer = ""
	local rb = ""
	local offset = math.floor(math.log(#stuff,16)) + 1
	offset = offset + (offset % 2)
	
	local formatstr = "%0"..tostring(offset).."x : %-"..tostring(linemax * 3).."s : %s"

	for c in string.gmatch(tostring(stuff), ".") do
		buffer = buffer..string.format("%02X ",string.byte(c))
		-- using string.gsub(c,"%c",".") didn't work in hydra, but
		-- I didn't dig any deeper -- this works.
		if string.byte(c) < 32 or string.byte(c) > 126 then
		    ascii = ascii.."."
		else
		    ascii = ascii..c
		end
		count = count + 1
		if count % linemax == 0 then
			rb = rb .. string.format(formatstr, count - linemax, buffer, ascii) .. "\n"
			buffer=""
			ascii=""
		end
	end
	if count % linemax ~= 0 then
		rb = rb .. string.format(formatstr, count - (count % linemax), buffer, ascii) .. "\n"
	end
	return rb
end

--- mjolnir._asm.toolkit.datetime(number) -> string
--- Function
--- takes the specified timevalue (or os.time() if not specified) and returns it in the
--- format I like, as this wasn't quite possible with lua's builtin date support.

module.datetime = function(theDate)
    local what = theDate or os.time()
    local date = module.shell('/bin/date -r '..what..' +"%l:%M %p, %v"').stdout[1]
    return date
end

--- mjolnir._asm.toolkit.specialkeys[...]
--- Variable
--- Array of symbols representing special keys in the mac environment
module.specialkeys = {
    ["escape"] = "⎋",
    ["tab"] = "⇥",
    ["backtab"] = "⇤",
    ["capslock"] = "⇪",
    ["shift"] = "⇧",
    ["ctrl"] = "⌃",
    ["alt"] = "⌥",
    ["option"] = "⌥",
    ["apple"] = "",
    ["cmd"] = "⌘",
    ["space"] = "␣",
    ["return"] = "⏎",
    ["return2"] = "↩",
    ["delete"] = "⌫",
    ["forwarddelete"] = "⌦",
    ["help"] = "﹖",
    ["home"] = "⇱",
    ["home alternate2"] = "↖",
    ["home alternate3"] = "↸",
    ["end"] = "⇲",
    ["end2"] = "↘",
    ["pageup"] = "⇞",
    ["pagedown"] = "⇟",
    ["up"] = "↑",
    ["up2"] = "⇡",
    ["down"] = "↓",
    ["down2"] = "⇣",
    ["left"] = "←",
    ["left2"] = "⇠",
    ["right"] = "→",
    ["right2"] = "⇢",
    ["padclear"] = "⌧",
    ["numlock"] = "⇭",
    ["padenter"] = "↩",
    ["padenter2"] = "⌤", -- apple preferred, but causes formatting issues with textgrids
    ["padenter3"] = "⎆", -- sun preferred, but causes formatting issues with textgrids
    ["eject"] = "⏏",
    ["power"] = "⌽",
}

--- mjolnir._asm.toolkit.sorted_keys(table[ , function]) -> function
--- Function
--- Iterator for getting keys from a table in a sorted order. Provide function 'f' as per _Programming_In_Lua,_3rd_ed_, page 52; otherwise order is ascii order ascending.
---
--- Similar to Perl's sort(keys %hash)
module.sorted_keys = function(t, f)
    if t then
        local a = {}
        for n in pairs(t) do table.insert(a, n) end
            table.sort(a, f)
            local i = 0      -- iterator variable
            local iter = function ()   -- iterator function
            i = i + 1
            if a[i] == nil then return nil
                else return a[i], t[a[i]]
            end
        end
        return iter
    else
        return function() return nil end
    end
end

--- mjolnir._asm.toolkit.mt_tools[...]
--- Variable
--- An array containing useful functions for metatables in a single location for reuse.
--- Currently defined:
---     table:get("path.key" [, default]) -- add to __index to retrieve a value for key at the specified path in table, or a default value, if it doesn't exist.
---     table:set("path.key", value [, build]) -- add to __index to set a value for key at the specified path in table, building up the tables along the way, if build is true.

module.mt_tools = {
    get = function(self, key_path, default)
        local root = self
        for part in string.gmatch(key_path, "[%w_]+") do
            root = root[part]
            if not root then return default end
        end
        return root
    end,
    set = function(self, key_path, value, build)
        local root = self
        local pathPart, keyPart

        for part, sep in string.gmatch(key_path, "([%w_]+)([^%w_]?)") do
            if sep ~= "" then
                if (not root[part] and build) or type(root[part]) == "table" then
                    root[part] = root[part] or {}
                    root = root[part]
                else
                    error("Part "..part.." of "..key_path.." either exists and is not a table, or does not exist and build not set to true.", 2)
                    return nil
                end
            else
                root[part] = value
                return root[part]
            end
        end
    end
}

-- Return Module Object --------------------------------------------------

return module
