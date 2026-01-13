# Building the Nostub Version

## Quick Start

The nostub version (`tunnel_nostub.asm`) is ready to build and run on any TI-89/89 Titanium without requiring DoorOS!

## Prerequisites

You need one of these toolchains:

### Option 1: TIGCC (Recommended)
- **Download**: http://tigcc.ticalc.org/
- **Platforms**: Windows, Linux, macOS
- **Includes**: A68k assembler, linker, IDE

### Option 2: GCC4TI
- **Download**: https://github.com/debrouxl/gcc4ti
- **Platforms**: Linux, macOS, Windows (via WSL)
- **More modern**: Active development

## Building

### Using TIGCC Command Line

```bash
# Navigate to the tunnel89 directory
cd /path/to/tunnel89

# Assemble the nostub version
a68k tunnel_nostub.asm -o tunnel_nostub.89z -g

# If you get errors about the SPRITE.HUF file, comment out the incbin line
```

### Using TIGCC IDE

1. Open TIGCC IDE
2. File → New → A68k Assembly Project
3. Add `tunnel_nostub.asm` to project
4. Project → Build (F9)
5. Output: `tunnel_nostub.89z`

### Build Options

- `-g`: Include debugging symbols (optional)
- `-i`: Show included files (optional)
- `-w`: Show warnings (recommended)

## Testing

### On Emulator (TiEmu)

1. **Install TiEmu**:
   ```bash
   # Ubuntu/Debian
   sudo apt-get install tiemu

   # macOS
   brew install tiemu
   ```

2. **Get a TI-89 ROM** (must own a real calculator)

3. **Load and run**:
   - Start TiEmu
   - File → Send file to TI
   - Select `tunnel_nostub.89z`
   - Press `2nd` + `-` (VAR-LINK)
   - Find "tunnel" and press ENTER

### On Real Hardware

1. **Install TI-Connect** from Texas Instruments

2. **Connect your TI-89** via USB

3. **Transfer**:
   - Open TI-Connect
   - TI Device Explorer
   - Drag `tunnel_nostub.89z` to calculator

4. **Run**:
   - Press `2nd` + `-` (VAR-LINK)
   - Find "tunnel"
   - Press ENTER

## Troubleshooting

### Build Errors

**Error: "SPRITE.HUF not found"**
- Comment out line 885: `; incbin "sprite.huf"`
- Title screen will still work (uses text, not graphic)

**Error: "push/pop not supported"**
- Replace `push.l` with `move.l reg,-(sp)`
- Replace `pop.l` with `move.l (sp)+,reg`
- Or use `movem.l` instead

**Error: "Unknown directive"**
- Make sure you're using A68k syntax
- Check assembler version (need 2.x+)

### Runtime Issues

**Black screen on startup**
- ROM might not be compatible
- Try different AMS version (2.05+ recommended)

**Keyboard not responding**
- Try pressing ON to wake calculator
- Check if stuck in a loop (ESC to exit)

**Sprites not appearing**
- Sprite functions rely on proper screen buffer
- Make sure LCD_MEM ($4C00) is accessible

**Crash on collision**
- This is intentional! Press ENTER to continue
- Check collision detection if behavior is wrong

## File Requirements

The nostub version needs:

**Required:**
- `tunnel_nostub.asm` - Main source file
- `SPRITE.HUF` - Huffman-compressed title (optional - text title works without it)

**Not needed (nostub handles these internally):**
- ❌ doorsos.h
- ❌ userlib.h
- ❌ graphlib.h
- ❌ ziplib.h

## What's Different from DoorOS Version?

| Feature | DoorOS Version | Nostub Version |
|---------|----------------|----------------|
| **Kernel required** | Yes (DoorOS) | No |
| **ROM calls** | DoorOS APIs | AMS ROM calls |
| **Title screen** | Compressed graphic | Text title |
| **Compatibility** | Limited | Excellent |
| **File size** | ~2.6 KB | ~3.0 KB |
| **Build system** | DoorOS SDK | TIGCC/GCC4TI |

## Performance

The nostub version should perform identically to the original:
- Same tunnel generation algorithm
- Same scrolling speed
- Same collision detection
- Same controls and gameplay

## Distribution

To share your built .89z file:

1. **No kernel required** - Users just copy and run!
2. **Include instructions**: "Copy to calculator, run from VAR-LINK"
3. **Test on multiple AMS versions**: 2.05, 2.08, 2.09 recommended
4. **Works on**: TI-89, TI-89 Titanium, TI-92+, V200

## Contributing

Want to improve the nostub version?

### Enhancement Ideas:
- Recreate original title screen graphic (uncompressed)
- Add custom name entry for high scores
- Improve high score display formatting
- Add sound effects (via AMS tone functions)
- Create color version for TI-89 Titanium

### How to Contribute:
1. Fork the repository
2. Make your improvements
3. Test thoroughly on emulator and hardware
4. Submit a pull request

## Resources

- **TIGCC Docs**: http://tigcc.ticalc.org/doc/
- **AMS ROM Calls**: http://www.technoplaza.net/
- **TI-89 Programming**: https://www.ticalc.org/programming/
- **68K Assembly**: http://www.freescale.com/68k/

## Credits

**Original Game**: Jordan Clifford (nike) - 2000
**Nostub Conversion**: 2026
**Build System**: TIGCC/GCC4TI
**Emulator**: TiEmu by Romain Liévin

---

Ready to race through some tunnels? Build it and go! 🏎️
