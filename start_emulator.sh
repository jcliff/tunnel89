#!/bin/bash

# TI-89 Tunnel Game Emulator Launcher
# Starts a web server and opens the emulator in your browser

echo "╔════════════════════════════════════════════════════════════╗"
echo "║         TI-89 TUNNEL GAME EMULATOR LAUNCHER                ║"
echo "║                    by nike (2000)                          ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check if port 8000 is already in use
if lsof -Pi :8000 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
    echo "✓ Server already running on port 8000"
else
    echo "Starting HTTP server on port 8000..."
    python3 -m http.server 8000 > server.log 2>&1 &
    SERVER_PID=$!
    echo "✓ Server started (PID: $SERVER_PID)"
    sleep 2
fi

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  EMULATOR READY!                                           ║"
echo "╠════════════════════════════════════════════════════════════╣"
echo "║  Open your browser and navigate to:                       ║"
echo "║                                                            ║"
echo "║      http://localhost:8000                                 ║"
echo "║                                                            ║"
echo "║  Then click 'LAUNCH TI-89 EMULATOR'                        ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "📚 For detailed instructions, see: EMULATOR_README.md"
echo ""
echo "🎮 GAME CONTROLS:"
echo "   LEFT/RIGHT arrows = Move car"
echo "   ESC = Exit"
echo "   ENTER = Start game"
echo "   +/- = Change difficulty"
echo ""
echo "💡 TIP: For the best experience loading the .89z file,"
echo "   install TiEmu desktop emulator (see README)."
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Try to open browser automatically
if command -v xdg-open > /dev/null; then
    echo "Opening browser..."
    xdg-open http://localhost:8000 2>/dev/null
elif command -v open > /dev/null; then
    echo "Opening browser..."
    open http://localhost:8000
elif command -v start > /dev/null; then
    echo "Opening browser..."
    start http://localhost:8000
else
    echo "Please open http://localhost:8000 in your browser manually"
fi

# Keep the script running
tail -f server.log
