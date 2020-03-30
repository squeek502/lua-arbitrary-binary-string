local abs = require('arbitrary-binary-string')

--
-- This is a basic sanity check to make sure it doesn't get tripped up on any
-- given single byte.
--
-- Fuzz testing (fuzz.lua) is better for ensuring that arbitrary *combinations*
-- of bytes don't cause problems.
--

-- make a string with one of every byte
local data = {}
for i=0,255 do
	table.insert(data, string.char(i))
end
data = table.concat(data)

-- test each pattern type
for _, pattern_name in ipairs({"ESCAPE_MINIMAL", "ESCAPE_CONTROL_CHARS", "ESCAPE_ALL_NONASCII"}) do
	local encode_pattern = abs[pattern_name]
	local encoded = abs.encode(data, encode_pattern)
	assert(abs.decode(encoded) == data, pattern_name)
	-- report the size increase for each type
	print(pattern_name .. ": " .. #data .. " bytes encoded to " .. #encoded .. " bytes ("..string.format("%.0f%%", (#encoded/#data)*100)..")")
end
