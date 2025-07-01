# Memory Analyzer

> Memory analysis tool written in BASIC for... Something, anything.

## Usage

```basic
RUN
```

### Commands

| Command | Function |
|---------|----------|
| D | Dump memory (hex/ASCII display) |
| S | Search for pattern in memory |
| G | Goto specific address |
| F | Fill memory range with byte |
| M | Memory statistics and analysis |
| R | Set memory range |
| H | Show help |
| Q | Quit analyzer |

### Navigation

- **N**: Next page (+256 bytes)
- **P**: Previous page (-256 bytes)

## Technical Details

- Uses PEEK/POKE operations for direct memory access
- Default address range: 0x0000 - 0xFFFF (configurable)
- Memory access limited to BASIC interpreter's permitted address space
- Pattern matching with sliding window algorithm
- Hex string conversion for address parsing using VAL("&H" + string)

## Requirements

- BASIC interpreter with PEEK/POKE support
- HEX$ function for hexadecimal conversion
- Memory access permissions within interpreter constraints

## Limitations

Memory access restricted to BASIC's allocated address space and system-permitted regions. Cannot access arbitrary physical memory, kernel space, or other process memory without elevated privileges.
