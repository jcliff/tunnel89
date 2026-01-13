#!/bin/bash

# Docker-based build script for Tunnel Nostub
# Builds the .89z file without requiring local TIGCC installation

echo "🐳 Building Tunnel Nostub with Docker..."
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found!"
    echo "Install Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Dockerfile exists, if not create it
if [ ! -f Dockerfile.build ]; then
    echo "Creating Dockerfile..."
    cat > Dockerfile.build << 'EOF'
FROM debian:bullseye-slim

# Install build dependencies
RUN apt-get update && apt-get install -y \
    wget \
    bzip2 \
    make \
    gcc \
    g++ \
    binutils \
    bison \
    flex \
    texinfo \
    libgmp-dev \
    libmpfr-dev \
    libmpc-dev \
    && rm -rf /var/lib/apt/lists/*

# Download and install TIGCC
WORKDIR /tmp
RUN wget -q http://tigcc.ticalc.org/linux/tigcc.tar.bz2 && \
    tar xjf tigcc.tar.bz2 && \
    cd tigcc && \
    ./install --prefix=/usr/local && \
    cd / && \
    rm -rf /tmp/tigcc*

# Set up work directory
WORKDIR /build

CMD ["bash"]
EOF
fi

# Build Docker image if it doesn't exist
if [[ "$(docker images -q tigcc-build:latest 2> /dev/null)" == "" ]]; then
    echo "Building Docker image (first time only, may take a few minutes)..."
    docker build -t tigcc-build:latest -f Dockerfile.build .
    if [ $? -ne 0 ]; then
        echo "❌ Docker image build failed"
        exit 1
    fi
    echo "✅ Docker image built successfully"
    echo ""
fi

# Build the nostub version
echo "Building tunnel_nostub.89z..."
docker run --rm -v "$(pwd)":/build tigcc-build:latest bash -c "
    a68k tunnel_nostub.asm -o tunnel_nostub.89z -g
"

if [ $? -eq 0 ] && [ -f tunnel_nostub.89z ]; then
    echo ""
    echo "✅ Build successful!"
    echo "📦 Output: tunnel_nostub.89z"
    echo ""
    echo "Next steps:"
    echo "  1. Transfer to TI-89: Use TI-Connect"
    echo "  2. Test in emulator: tiemu tunnel_nostub.89z"
    echo "  3. Run on calculator: 2nd + - → Find 'tunnel' → ENTER"
else
    echo ""
    echo "❌ Build failed"
    echo "Check tunnel_nostub.asm for syntax errors"
    exit 1
fi
