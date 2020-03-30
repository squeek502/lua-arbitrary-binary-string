local abs = {}

local escapes = {
	['\a'] = '\\a',
	['\b'] = '\\b',
	['\f'] = '\\f',
	['\n'] = '\\n',
	['\r'] = '\\r',
	['\t'] = '\\t',
	['\v'] = '\\v',
	['\\'] = '\\\\',
	['"'] = '\\"',
}

abs.ESCAPE_MINIMAL = '[\r\n\\"]'
abs.ESCAPE_CONTROL_CHARS = '[%c\r\n\\"]'
abs.ESCAPE_ALL_NONASCII = '[%c\r\n\\"\128-\255]'

function abs.encode(data, escape_pattern)
	if not escape_pattern then escape_pattern = abs.ESCAPE_MINIMAL end
	return data:gsub(escape_pattern, function(char)
		return escapes[char] or string.format('\\%03d', string.byte(char))
	end)
end

function abs.decode(encoded)
	return abs.loadchunk(abs.getchunk(encoded))
end

function abs.quotedstring(encoded)
	return '"' .. encoded .. '"'
end

function abs.getchunk(encoded)
	return "return " .. abs.quotedstring(encoded)
end

function abs.loadchunk(chunk)
	local loadfn = loadstring or load
	return assert(loadfn(chunk))()
end

return abs
