local abs = require('arbitrary-binary-string')

-- arguments minus any flags/options
local argv = {}
-- any flags/options
local options = {}
-- lookup for valid flags
local valid_flags = {
	["help"]=true,
	["escape-minimal"]=true,
	["escape-control-chars"]=true,
	["escape-all-nonascii"]=true,
}
for i=1,#arg do
  local option = arg[i]:match("^%-%-?([^=]+)$")
  if option and valid_flags[option] then
	  options[option] = true
	else
		table.insert(argv, arg[i])
	end
end

if options.help then
	local invocation = (arg[-1] and (arg[-1] .. " ") or "") .. arg[0]
	print("Usage: " .. invocation .. " [flags] [input_filepath] [output_filepath]")
	print("\nArguments:")
	print("  input_filepath           if not specified, stdin is used")
	print("  output_filepath          if not specified, stdout is used")
	print("\nFlags:")
	print("  --help                   print this help screen and exit")
	print("  --escape-minimal         [default] escape only the chars necessary (leave most control chars unescaped)")
	print("  --escape-control-chars   escape all control chars (leave extended ascii unescaped)")
	print("  --escape-all-nonascii    escape all non-ascii chars (only leave printable ascii unescaped)")
	return
end
local inpath, outpath = argv[1], argv[2]

local infile = inpath and assert(io.open(inpath, 'rb')) or io.stdin
local data = infile:read("*all")
if inpath then infile:close() end

local escape_pattern = nil
-- escape-all-nonascii takes precedence
if options["escape-all-nonascii"] then
	escape_pattern = abs.ESCAPE_ALL_NONASCII
elseif options["escape-control-chars"] then
	escape_pattern = abs.ESCAPE_CONTROL_CHARS
end

local chunk = abs.getchunk(abs.encode(data, escape_pattern))

-- sanity check
assert(abs.loadchunk(chunk) == data, "decoded output didn't match input, this is a bug in the arbitrary-binary-string library")

local outfile = outpath and assert(io.open(outpath, 'wb')) or io.stdout
outfile:write(chunk)
if outpath then outfile:close() end
