# Tunnel v2.0 - Nostub Conversion Guide

## What is a Nostub Program?

**Nostub programs** are TI-89 assembly programs that run on **stock AMS** (the official TI operating system) without requiring kernels like DoorOS.

### Advantages of Nostub

- ✅ **No kernel required** - Runs on stock TI-89/89 Titanium/92+/V200
- ✅ **More compatible** - Works with modern emulators (TiEmu, etc.)
- ✅ **Smaller** - No 12KB kernel overhead
- ✅ **Easier distribution** - Users don't need to install DoorOS first
- ✅ **More stable** - Uses official AMS ROM calls instead of kernel hacks

### Comparison

| Feature | DoorOS Version | Nostub Version |
|---------|----------------|----------------|
| **Requires kernel** | Yes (DoorOS) | No |
| **Works on stock OS** | No | Yes |
| **File size** | Small (~2.6 KB) | Similar |
| **Compatibility** | Limited | Excellent |
| **Emulator support** | Poor | Excellent |
| **Distribution** | Complex | Simple |

## Conversion Status

### ✅ Completed

1. **Structure conversion**: Converted from DoorOS headers to nostub format
2. **ROM Call definitions**: Added AMS ROM call wrappers
3. **Core game logic**: Preserved original tunnel generation, scrolling, collision
4. **Direct hardware access**: Maintained screen buffer and keyboard scanning
5. **Basic framework**: Set up nostub entry points and declarations

### 🚧 TODO (Needs Implementation)

The following DoorOS library functions need nostub implementations:

#### High Priority
1. **Huffman decompression** (`huffman_extract`)
   - Original uses `ziplib::extract`
   - Need to implement Huffman decoder for title screen
   - Alternative: Pre-decompress title graphic offline

2. **Sprite drawing** (`put_sprite2_impl`, `put_sprite_mask_impl`)
   - Original uses `graphlib::put_sprite2` and `put_sprite_mask`
   - Need to implement masked sprite blitting
   - Critical for drawing the car and clearing it

3. **Dialog box** (`show_dialog_impl`)
   - Original uses `graphlib::show_dialog`
   - Displays "CRASH!!!" message
   - Could be simplified to just pause game

#### Medium Priority
4. **Name input** (`ReadName`)
   - Original uses DoorOS keyboard functions
   - Need to implement text input for high scores
   - Uses character drawing

5. **String positioning** (`ShowScores`)
   - Need to draw strings at specific (x,y) coordinates
   - Currently using AMS DrawStrXY but needs proper positioning

#### Low Priority
6. **Improved random generator**
   - Current LCG implementation works but is basic
   - Could use AMS timer for better seed

7. **Better idle/keypress handling**
   - Current implementation is basic
   - Could use AMS event system

## Technical Details

### ROM Calls Used

The nostub version uses these official AMS ROM calls:

| ROM Call | Address | Function | Purpose |
|----------|---------|----------|---------|
| #$177 | $2F6 | FontSetSys | Set system font |
| #$124 | $250 | DrawStrXY | Draw string at x,y |
| #$00A | $D2 | idle | System idle/wait |

### Hardware Access

Direct hardware access is preserved (works in nostub):

- **$4C00**: LCD framebuffer (160×100, 30 bytes/row)
- **$600018**: Keyboard port (scan)
- **$60001B**: Keyboard data

### Build Process

To build the nostub version, you'll need:

1. **TIGCC** or **GCC4TI** toolchain
2. **A68k assembler** (or compatible)
3. The sprite data file (`SPRITE.HUF`)

Build command (once complete):
```bash
a68k tunnel_nostub.asm -o tunnel_nostub.89z
```

## Implementation Notes

### What Was Changed

**Includes**:
```asm
; OLD (DoorOS):
include "doorsos.h"
include "userlib.h"
include "graphlib.h"
include "ziplib.h"

; NEW (Nostub):
; No includes needed - use direct ROM calls
xdef    _ti89           ; Declare calculator compatibility
xdef    _ti92plus
xdef    _v200
```

**Library Calls**:
```asm
; OLD:
jsr     doorsos::DrawStrXY
jsr     userlib::idle_loop
jsr     graphlib::clr_scr

; NEW:
jsr     call_124        ; AMS DrawStrXY ROM call
bsr     idle_call       ; Local implementation
bsr     clr_scr         ; Direct screen clear
```

**Keyboard Access**:
```asm
; OLD:
clr.l   (doorsos::kb_vars+$1c)

; NEW:
clr.l   kb_state        ; Local variable
```

### What Stayed The Same

- ✅ All game logic (tunnel generation, scoring, etc.)
- ✅ Screen scrolling algorithm
- ✅ Collision detection
- ✅ Direct hardware keyboard scanning
- ✅ Sprite data format
- ✅ High score system
- ✅ Difficulty levels

## Next Steps

### For Developers

To complete the nostub conversion:

1. **Implement sprite functions**:
   - Study the sprite format (width, height, mask, data)
   - Implement pixel-level blitting with masking
   - Test with the car sprite

2. **Add Huffman decompressor**:
   - Port from ziplib source if available
   - Or pre-decompress `SPRITE.HUF` offline
   - Load decompressed data at build time

3. **Simplify dialog**:
   - Could just be a pause with message
   - Or use AMS dialog functions

4. **Test thoroughly**:
   - TiEmu with AMS ROM
   - Real TI-89 hardware
   - TI-89 Titanium

### For Users

Once complete, the nostub version will:

- Work on **any TI-89** without modifications
- Run in **any emulator** that supports AMS
- Be **easier to distribute** (no kernel installation)
- Be **more stable** (no kernel conflicts)

## Resources

- [TIGCC Documentation](http://tigcc.ticalc.org/doc/)
- [Nostub Assembly Guide](https://www.tigen.org/kevin.kofler/ti89prog/asmnstb.htm)
- [AMS ROM Call Reference](https://www.ticalc.org/pub/89/asm/)
- [TI-89 Technical Info](https://www.ocf.berkeley.edu/~pad/faq/ti89.html)

## Sources

This conversion guide is based on research from:
- [TI-89 Flash App Build Guide](https://github.com/deisele/flashapp-build-guide)
- [Nostub Assembly Programming Guide](https://www.tigen.org/kevin.kofler/ti89prog/asmnstb.htm)
- [TIGCC Documentation](http://tigcc.ticalc.org/doc/httigcc.html)
- [Cemetech TI-89 Assembly Forums](https://www.cemetech.net/forum/viewtopic.php?t=11291)

---

**Status**: 🚧 **Work in Progress** - Core framework complete, library functions need implementation

**Original**: tunnel.asm (DoorOS version, fully functional)
**Nostub**: tunnel_nostub.asm (framework complete, needs library implementations)
