#!/bin/bash

# SPDX-FileCopyrightText: 2025 Chen Linxuan <me@black-desk.cn>
#
# SPDX-License-Identifier: MIT

# Script to generate codebrowser HTML from kernel source
# Usage: generate-codebrowser.sh [options]

set -euo pipefail

# Default values
INPUT_DIR="/mnt/input"
OUTPUT_DIR="/mnt/output"
PROJECT_NAME="kernel"
BUILD_DIR=""
DATA_URL="../data"

# Function to show help
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Generate codebrowser HTML from kernel source code.

OPTIONS:
    -i DIR      Input directory containing kernel source (default: /mnt/input)
    -o DIR      Output directory for generated HTML (default: /mnt/output)
    -b DIR      Build directory containing compile_commands.json
    -p NAME     Project name (default: kernel)
    -d URL      Data URL for CSS/JS files (default: ../data)
    -h          Show this help message

EXAMPLE:
    $(basename "$0") -i /mnt/input/linux -o /mnt/output -b /mnt/input/linux/build -p "Linux Kernel"

EOF
}

# Parse command line arguments
while getopts "i:o:b:p:d:h" opt; do
    case $opt in
        i) INPUT_DIR="$OPTARG" ;;
        o) OUTPUT_DIR="$OPTARG" ;;
        b) BUILD_DIR="$OPTARG" ;;
        p) PROJECT_NAME="$OPTARG" ;;
        d) DATA_URL="$OPTARG" ;;
        h) show_help; exit 0 ;;
        *) echo "Invalid option. Use -h for help."; exit 1 ;;
    esac
done

# Validate inputs
if [[ ! -d "$INPUT_DIR" ]]; then
    echo "Error: Input directory '$INPUT_DIR' does not exist."
    exit 1
fi

if [[ -z "$BUILD_DIR" ]]; then
    echo "Error: Build directory must be specified with -b option."
    exit 1
fi

if [[ ! -f "$BUILD_DIR/compile_commands.json" ]]; then
    echo "Error: compile_commands.json not found in '$BUILD_DIR'."
    echo "Please build the kernel with 'make LLVM=1' to generate compile_commands.json."
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo "Starting codebrowser generation..."
echo "Input: $INPUT_DIR"
echo "Output: $OUTPUT_DIR"
echo "Build: $BUILD_DIR"
echo "Project: $PROJECT_NAME"

# Run codebrowser generator
codebrowser_generator \
    -a \
    -o "$OUTPUT_DIR" \
    -b "$BUILD_DIR" \
    -p "$PROJECT_NAME:$INPUT_DIR" \
    -d "$DATA_URL"

# Generate index
if command -v codebrowser_indexgenerator &> /dev/null; then
    echo "Generating index..."
    codebrowser_indexgenerator "$OUTPUT_DIR"
else
    echo "Warning: codebrowser_indexgenerator not found. Index will not be generated."
fi

echo "Codebrowser generation complete!"
echo "Output directory: $OUTPUT_DIR"
