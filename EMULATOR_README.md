# TI-89 Tunnel Game Emulator Setup

## Quick Start

### Option 1: Web-Based Emulator (Easiest!)

1. **Start the server** (if not already running):
   ```bash
   python3 -m http.server 8000
   ```

2. **Open your browser** and navigate to:
   ```
   http://localhost:8000
   ```

3. **Click "LAUNCH TI-89 EMULATOR"** to start the calculator

4. **The emulator will boot** with PedroM (open-source TI-89 OS)

### Loading the Game

The web-based emulator uses PedroM, which is an open-source alternative to the TI-89 operating system. Unfortunately, directly loading `.89z` files into web-based emulators can be tricky.

#### Method 1: Using TiEmu (Desktop Emulator - Recommended!)

For the best experience running the actual game, I recommend using TiEmu:

1. **Install TiEmu**:
   ```bash
   # On Ubuntu/Debian:
   sudo apt-get install tiemu

   # On macOS (with Homebrew):
   brew install tiemu

   # On Windows:
   # Download from: http://lpg.ticalc.org/prj_tiemu/
   ```

2. **Start TiEmu**:
   ```bash
   tiemu
   ```

3. **Load the ROM** (first time only):
   - TiEmu will ask for a ROM file
   - You can use a TI-89 ROM dump (if you own a TI-89)
   - Or search for "PedroM ROM" for an open-source alternative

4. **Transfer the game**:
   - In TiEmu, go to `File` → `Send file to TI`
   - Navigate to this directory and select `tunnel.89z`
   - The game will be transferred to the calculator

5. **Run the game**:
   - Press `2nd` + `-` (VAR-LINK)
   - Navigate to find `tunnel`
   - Press `ENTER` to run it

#### Method 2: Using the Web Emulator for Development

The web-based emulator is great for:
- Testing calculator functions
- Learning TI-89 programming
- Running BASIC programs
- Using the calculator normally

However, loading external `.89z` files requires:
1. The emulator to support file uploads (implementation varies)
2. Or manual typing of smaller programs

#### Method 3: Real Hardware!

If you have an actual TI-89:

1. **Install TI-Connect** (from TI's website)
2. **Connect your TI-89** via USB cable
3. **Use TI-Connect** to transfer `tunnel.89z` to your calculator
4. **Run it** from VAR-LINK (`2nd` + `-`)

## Game Controls

Once you get the game running:

- **LEFT/RIGHT Arrows**: Move your car
- **ESC**: Exit to menu
- **ENTER**: Start game
- **F1 (or ON)**: Pause
- **+/- on menu**: Change difficulty

## Game Features

- **3 Difficulty Levels**: Easy, Medium, Hard
- **High Scores**: Top 4 racers saved per difficulty
- **Dynamic Tunnel**: Randomly shifting walls
- **Collision Detection**: Don't crash!

## File Structure

```
tunnel89/
├── index.html              # Launcher page (you are here!)
├── emulator/               # TI-89 web emulator
│   ├── index.html
│   ├── js/
│   │   ├── v12.js         # Emulator core
│   │   └── calcrom.js     # PedroM ROM
│   └── ...
├── tunnel.89z              # The game (compiled)
├── tunnel.asm              # Source code (68K assembly)
├── SPRITE.HUF              # Compressed title screen
└── README                  # Original README

```

## Technical Details

**Language**: Motorola 68000 Assembly
**Target**: TI-89 Calculator
**Display**: 160×100 monochrome
**Memory**: Direct framebuffer access at $4C00
**Compression**: Huffman encoding (ziplib)

### Code Highlights

- **Line 269-279**: Screen scrolling routine (copies 30 bytes × 94 lines)
- **Line 226-266**: Dynamic tunnel drawing
- **Line 283-300**: Collision detection (pixel testing)
- **Line 97-213**: Main game loop
- **Line 327-367**: High score management

## Troubleshooting

### Web Emulator Not Working?
- Make sure JavaScript is enabled
- Try a different browser (Chrome/Firefox recommended)
- Check browser console for errors (F12)

### Can't Load tunnel.89z in Web Emulator?
- This is normal - web emulators have limited file loading
- Use TiEmu (desktop) instead for running `.89z` files

### Server Won't Start?
- Port 8000 might be in use
- Try: `python3 -m http.server 8080` (different port)
- Or: `lsof -i :8000` to see what's using port 8000

## Resources

- **TiEmu**: http://lpg.ticalc.org/prj_tiemu/
- **TI-89 Programming**: https://www.ticalc.org/
- **68K Assembly Docs**: https://tiplanet.org/
- **PedroM OS**: Open-source TI-89 operating system

## About the Original Code

From the year 2000, when:
- TI-89s were the most powerful calculators
- Students wrote games in assembly during math class
- Memory was measured in kilobytes
- Every byte mattered

> "It is unlikely to get any updates, as I no longer speak 68K assembly
> (not that I ever spoke it too well)"
> — Original README

Enjoy this piece of calculator gaming history! 🎮

## Sources

Based on research from:
- [TI-89 Online Simulator](https://ti89-simulator.com/)
- [GitHub - gbraad/ti89-simulator](https://github.com/gbraad/ti89-simulator)
- [TIPlanet JavaScript TI-68k Emulator](https://tiplanet.org/emu68k_fork/)
