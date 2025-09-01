#!/bin/bash

# SPDX-FileCopyrightText: 2025 Chen Linxuan <me@black-desk.cn>
#
# SPDX-License-Identifier: MIT

# Script to build Linux kernel with Clang for codebrowser
# This script automatically generates compile_commands.json for codebrowser usage

set -euo pipefail

CONFIG="defconfig"
JOBS=$(nproc)
ARCH="x86_64"
SOURCE_DIR="/mnt/input"
BUILD_DIR="/mnt/build"

# Function to show help
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Build Linux kernel with Clang/LLVM toolchain and generate compile_commands.json for codebrowser.

OPTIONS:
    -s DIR      Source directory (default: /mnt/input)
    -b DIR      Build directory (default: /mnt/build)
    -c CONFIG   Kernel config (default: defconfig)
    -j JOBS     Number of parallel jobs (default: $(nproc))
    -a ARCH     Target architecture (default: x86_64)
    -h          Show this help message

EXAMPLES:
    $(basename "$0")                    # Build with default settings
    $(basename "$0") -c allmodconfig    # Build with allmodconfig
    $(basename "$0") -a arm64           # Build for ARM64
    $(basename "$0") -b /tmp/build      # Use custom build directory

ENVIRONMENT VARIABLES:
    The following are automatically set for Clang builds:
    LLVM=1, CC=clang, CXX=clang++, LD=ld.lld

EOF
}

# Parse command line arguments
while getopts "s:b:c:j:a:h" opt; do
    case $opt in
        s) SOURCE_DIR="$OPTARG" ;;
        b) BUILD_DIR="$OPTARG" ;;
        c) CONFIG="$OPTARG" ;;
        j) JOBS="$OPTARG" ;;
        a) ARCH="$OPTARG" ;;
        h) show_help; exit 0 ;;
        *) echo "Invalid option. Use -h for help."; exit 1 ;;
    esac
done

# Get remaining arguments (not used, but keep for compatibility)
shift $((OPTIND-1))

# Validate inputs
if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: Source directory '$SOURCE_DIR' does not exist."
    exit 1
fi

if [[ ! -f "$SOURCE_DIR/Makefile" ]]; then
    echo "Error: '$SOURCE_DIR' does not appear to be a Linux kernel source directory."
    exit 1
fi

# Create build directory
mkdir -p "$BUILD_DIR"

echo "Building Linux kernel with Clang/LLVM for codebrowser..."
echo "Source: $SOURCE_DIR"
echo "Build: $BUILD_DIR"
echo "Config: $CONFIG"
echo "Architecture: $ARCH"
echo "Jobs: $JOBS"
echo "Compiler: $(clang --version | head -n1)"

# Configure kernel if no .config exists
if [[ ! -f "$BUILD_DIR/.config" ]]; then
    echo "Configuring kernel..."
    make -C "$SOURCE_DIR" O="$BUILD_DIR" LLVM=1 -j"$JOBS" "$CONFIG"
fi

# Re-run olddefconfig with LLVM=1 to ensure proper configuration for Clang
echo "Running olddefconfig with LLVM=1..."
make -C "$SOURCE_DIR" O="$BUILD_DIR" LLVM=1 -j"$JOBS" olddefconfig

# Enable compile_commands.json generation
if [[ -f "$BUILD_DIR/.config" ]]; then
    echo "Enabling compile_commands.json generation..."
    "$SOURCE_DIR"/scripts/config --file "$BUILD_DIR/.config" --set-str COMPILE_TEST y 2>/dev/null || true
fi

# Generate compile_commands.json directly
echo "Generating compile_commands.json..."
make -C "$SOURCE_DIR" O="$BUILD_DIR" LLVM=1 -j"$JOBS" compile_commands.json

echo "Kernel configuration and compile_commands.json generation complete!"
echo "compile_commands.json is available at: $BUILD_DIR/compile_commands.json"
