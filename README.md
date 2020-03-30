# lua-arbitrary-binary-string

A Lua library/tool to convert arbitrary binary data into a Lua string literal with various levels of printability.

## As A Command Line Tool

```
Usage: lua main.lua [flags] [input_filepath] [output_filepath]

Arguments:
  input_filepath           if not specified, stdin is used
  output_filepath          if not specified, stdout is used

Flags:
  --help                   print this help screen and exit
  --escape-minimal         [default] escape only the chars necessary (leave most control chars unescaped)
  --escape-control-chars   escape all control chars (leave extended ascii unescaped)
  --escape-all-nonascii    escape all non-ascii chars (only leave printable ascii unescaped)
```

## Output / Options

Each 'level' of escaping presents a trade-off between printability (i.e. being able to embed the result in a .lua file without making text editors think its a binary file) and size (the more characters that are escaped, the larger the encoded string will be).

Here is a table showing an overview of the options:

| Escape Option | Expected Encoded Size Increase | Printability |
| --- | --- | --- |
| `ESCAPE_MINIMAL` (default) | ~103% | Contains unescaped embedded NUL and control characters; almost guaranteed to make text editors treat the file as a binary file |
| `ESCAPE_CONTROL_CHARS` | ~135% | Contains unescaped extended ASCII characters, which may have printable representations in text editors (but may look strange) |
| `ESCAPE_ALL_NONASCII` | ~275% | Escapes everything except standard printable ASCII characters. Will be printable in all text editors, but greatly inflates the size of the embedded data. |

## As A Library

See [`arbitary-binary-string.lua`](arbitrary-binary-string.lua). I haven't documented it/made it easy to use because I don't think it has much utility as a library.
