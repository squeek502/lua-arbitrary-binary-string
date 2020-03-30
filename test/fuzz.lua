local abs = require('arbitrary-binary-string')

--
-- Usage:
--  with no arguments, runs forever (or until a failing case is hit)
--  with 1 argument: uses the argument as an iteration limit, will exit after that many tries
--

local limit = tonumber(arg[1])

math.randomseed(os.time())

local function randombytes(len)
	if not len then len = 256 end
	local data = {}
	for _=1,len do
		table.insert(data, string.char(math.random(0, 255)))
	end
	return table.concat(data)
end

local function fail(i, data, encode_pattern)
	io.stderr:write("\r" .. i .. ": decoded output did not match input when using "..encode_pattern.."\nWriting failing data to fuzz.dat ...")
	local outfile = assert(io.open('fuzz.dat', 'wb'))
	outfile:write(data)
	outfile:flush()
	outfile:close()
	os.exit(1, true)
end

local tried = 0
while true do
	if limit and tried >= limit then
		io.stdout:write('\r' .. tried .. '\n')
		break
	end

	local data = randombytes()

	for _, pattern_name in ipairs({"ESCAPE_MINIMAL", "ESCAPE_CONTROL_CHARS", "ESCAPE_ALL_NONASCII"}) do
		local encode_pattern = abs[pattern_name]
		local encoded = abs.encode(data, encode_pattern)
		local result = abs.decode(encoded)
		if data ~= result then
			fail(tried, data, pattern_name)
		end
	end

	tried = tried + 1
	if tried % 1000 == 0 then
		io.stdout:write('\r' .. tried)
	end
end
