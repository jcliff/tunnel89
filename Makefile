# Makefile for Tunnel Nostub Version
# Requires TIGCC or GCC4TI toolchain

# Output filename
TARGET = tunnel_nostub
SOURCE = tunnel_nostub.asm

# Assembler (a68k from TIGCC)
AS = a68k
ASFLAGS = -g

# Alternative: use tigcc wrapper
TIGCC = tigcc
TIGCCFLAGS = -Os

# Pack to .89z format
PACK = pack-ti89
PACKFLAGS =

.PHONY: all clean nostub help install-tigcc

all: nostub

# Build nostub version
nostub: $(SOURCE)
	@echo "Building nostub version..."
	@if command -v $(AS) > /dev/null 2>&1; then \
		$(AS) $(ASFLAGS) $(SOURCE) -o $(TARGET).89z; \
		echo "✅ Built $(TARGET).89z"; \
	else \
		echo "❌ Error: a68k not found"; \
		echo "Install TIGCC: make install-tigcc"; \
		exit 1; \
	fi

# Clean build artifacts
clean:
	@echo "Cleaning..."
	@rm -f $(TARGET).89z $(TARGET).sym $(TARGET).lst
	@rm -f *.o *.bak *~
	@echo "✅ Clean complete"

# Show help
help:
	@echo "Tunnel Nostub Build System"
	@echo ""
	@echo "Targets:"
	@echo "  make nostub      - Build nostub version (default)"
	@echo "  make clean       - Remove build artifacts"
	@echo "  make install-tigcc - Show TIGCC installation instructions"
	@echo "  make test        - Build and test in TiEmu"
	@echo "  make help        - Show this help"
	@echo ""
	@echo "Requirements:"
	@echo "  - TIGCC toolchain (a68k assembler)"
	@echo "  - Or: Docker (see docker-build target)"

# Installation instructions
install-tigcc:
	@echo "TIGCC Installation Instructions"
	@echo "================================"
	@echo ""
	@echo "Linux:"
	@echo "  wget http://tigcc.ticalc.org/linux/tigcc.tar.bz2"
	@echo "  tar xjf tigcc.tar.bz2"
	@echo "  cd tigcc"
	@echo "  ./install"
	@echo ""
	@echo "macOS:"
	@echo "  brew install tigcc"
	@echo "  # Or build from source"
	@echo ""
	@echo "Windows:"
	@echo "  Download from: http://tigcc.ticalc.org/"
	@echo "  Run tigcc_setup.exe"
	@echo ""
	@echo "Alternative - GCC4TI:"
	@echo "  git clone https://github.com/debrouxl/gcc4ti"
	@echo "  cd gcc4ti && make"

# Test with TiEmu
test: nostub
	@if command -v tiemu > /dev/null 2>&1; then \
		echo "Starting TiEmu..."; \
		tiemu $(TARGET).89z & \
	else \
		echo "TiEmu not installed"; \
		echo "Install: sudo apt-get install tiemu"; \
	fi

# Docker-based build (no local TIGCC needed!)
docker-build:
	@echo "Building with Docker..."
	@docker run --rm -v $(PWD):/work -w /work \
		debian:bullseye bash -c " \
		apt-get update && \
		apt-get install -y wget bzip2 make gcc && \
		wget -q http://tigcc.ticalc.org/linux/tigcc.tar.bz2 && \
		tar xjf tigcc.tar.bz2 && \
		cd tigcc && ./install --prefix=/usr/local && \
		cd /work && \
		a68k $(SOURCE) -o $(TARGET).89z"
	@echo "✅ Docker build complete"
