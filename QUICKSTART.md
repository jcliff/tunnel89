# 🏎️ TUNNEL v1.6 - Quick Start Guide

## 🌐 Access Online (Easiest!)

**Already deployed to the web?** Just visit:
```
https://jcliff.github.io/tunnel89/
```

Not deployed yet? See **DEPLOYMENT.md** for 2-minute setup instructions!

---

## 💻 Local Setup (Alternative)

### Step 1: Start the Server

```bash
./start_emulator.sh
```

**OR manually:**

```bash
python3 -m http.server 8000
```

### Step 2: Open Your Browser

Navigate to: **http://localhost:8000**

### Step 3: Choose Your Path

#### Option A: Web-Based Emulator (Browse & Explore)

1. Click **"LAUNCH TI-89 EMULATOR"**
2. Wait for PedroM to boot
3. Explore the TI-89 interface
4. Use it as a calculator

**Note:** Loading `.89z` files in web emulators is limited. For actual gameplay, see Option B.

#### Option B: Desktop Emulator (Actually Play the Game!)

1. **Install TiEmu:**
   ```bash
   # Ubuntu/Debian
   sudo apt-get install tiemu

   # macOS
   brew install tiemu
   ```

2. **Download the game file:**
   - Click the download link on the main page
   - Or grab `tunnel.89z` from this directory

3. **Run TiEmu and load the game:**
   ```bash
   tiemu
   # Then: File → Send file to TI → Select tunnel.89z
   ```

4. **Launch the game:**
   - Press `2nd` + `-` (VAR-LINK)
   - Find "tunnel"
   - Press `ENTER`

5. **PLAY!** 🎮

## Game Controls

- **LEFT/RIGHT**: Move car
- **ENTER**: Start game
- **ESC**: Exit
- **+/-**: Change difficulty (on menu)
- **F1/ON**: Pause

## What You'll See

```
┌─────────────────────────────┐
│      TUNNEL v1.6            │
│   By Jordan Clifford        │
│                             │
│   TOP FOUR RACERS           │
│   1) [Name]      [Score]    │
│   2) [Name]      [Score]    │
│   3) [Name]      [Score]    │
│   4) [Name]      [Score]    │
│                             │
│   < EASY | MEDIUM | HARD >  │
│                             │
│   Press ENTER to start      │
└─────────────────────────────┘
```

## Files in This Repo

```
tunnel89/
├── tunnel.89z              ← The game (load this!)
├── tunnel.asm              ← Source code (68K assembly)
├── SPRITE.HUF              ← Compressed graphics
├── README                  ← Original README from 2000
├── index.html              ← Main launcher page
├── start_emulator.sh       ← Easy launcher script
├── EMULATOR_README.md      ← Detailed docs
├── QUICKSTART.md           ← This file!
└── emulator/               ← Web-based TI-89 emulator
    ├── index.html
    └── js/...
```

## Troubleshooting

**Server won't start?**
- Port 8000 in use: `python3 -m http.server 8080` (use different port)

**Can't load tunnel.89z in web emulator?**
- This is normal! Web emulators have limited file support
- Use TiEmu (desktop) instead

**Emulator page blank?**
- Check JavaScript is enabled
- Try Chrome or Firefox
- Check browser console (F12) for errors

**Want to play on real hardware?**
- Install TI-Connect from Texas Instruments
- Connect TI-89 via USB
- Transfer tunnel.89z
- Run from VAR-LINK

## The Original Experience

This game was written in **2000** using:
- **68000 Assembly Language**
- **160×100 monochrome display**
- **Direct hardware access** (framebuffer at $4C00)
- **~2.6 KB** of pure nostalgia

### Fun Facts

- Scrolls screen by copying 2,820 bytes per frame
- Uses Huffman compression for the title screen
- Includes custom sprite masking routines
- Direct keyboard port scanning ($600018)
- Three difficulty levels with different delay values
- High score persistence across sessions

## For the Curious

Want to see how it works? Check out `tunnel.asm` for:
- Line 269: Screen scrolling magic
- Line 226: Dynamic tunnel generation
- Line 283: Collision detection
- Line 97: Main game loop
- Line 584: Huffman-compressed sprite data

## Support

Having issues? Check:
1. `EMULATOR_README.md` for detailed instructions
2. Server logs: `cat server.log`
3. Browser console (F12 → Console)

## Original Author's Note

> "It is unlikely to get any updates, as I no longer speak 68K assembly
> (not that I ever spoke it too well)"

A beautiful snapshot of early 2000s calculator gaming! 🎮✨

---

**Ready to race?** Run `./start_emulator.sh` and let's go! 🏁
