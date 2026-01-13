#!/bin/bash

# Simple build script for Tunnel Nostub
# Tries multiple build methods

set -e

echo "🏎️  Tunnel Nostub Build Script"
echo "================================"
echo ""

SOURCE="tunnel_nostub.asm"
OUTPUT="tunnel_nostub.89z"

# Method 1: Try local TIGCC
if command -v a68k &> /dev/null; then
    echo "✅ Found a68k (TIGCC)"
    echo "Building with local TIGCC..."
    a68k "$SOURCE" -o "$OUTPUT" -g
    echo "✅ Build successful: $OUTPUT"
    exit 0
fi

# Method 2: Try Make
if command -v make &> /dev/null && [ -f Makefile ]; then
    echo "⚙️  Trying make..."
    make nostub
    echo "✅ Build successful: $OUTPUT"
    exit 0
fi

# Method 3: Try Docker
if command -v docker &> /dev/null; then
    echo "🐳 TIGCC not found locally, trying Docker build..."
    ./build_docker.sh
    exit $?
fi

# No build method available
echo ""
echo "❌ No build method available!"
echo ""
echo "Options:"
echo "  1. Install TIGCC:"
echo "     Linux: wget http://tigcc.ticalc.org/linux/tigcc.tar.bz2 && tar xjf tigcc.tar.bz2 && cd tigcc && ./install"
echo "     macOS: brew install tigcc"
echo "     Windows: Download from http://tigcc.ticalc.org/"
echo ""
echo "  2. Install Docker:"
echo "     https://docs.docker.com/get-docker/"
echo "     Then run: ./build_docker.sh"
echo ""
echo "  3. Use online build service:"
echo "     Upload tunnel_nostub.asm to ticalc.org IDE"
echo ""
exit 1
