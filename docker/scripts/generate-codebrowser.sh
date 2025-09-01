#!/bin/bash

# SPDX-FileCopyrightText: 2025 Chen Linxuan <me@black-desk.cn>
#
# SPDX-License-Identifier: MIT

# Script to generate codebrowser HTML from kernel source
# Usage: generate-codebrowser.sh [options]

set -euo pipefail

# Variables (no default values)
INPUT_DIR=""
OUTPUT_DIR=""
PROJECT_NAME=""
BUILD_DIR=""
PROJECT_VERSION=""

# Function to show help
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Generate codebrowser HTML from kernel source code.

OPTIONS:
    -i DIR      Input directory containing kernel source (required)
    -o DIR      Output directory for generated HTML (required)
    -b DIR      Build directory containing compile_commands.json (required)
    -p NAME     Project name (required)
    -v VERSION  Project version (required)
    -h          Show this help message

EXAMPLE:
    $(basename "$0") -i /mnt/input/linux -o /mnt/output -b /mnt/input/linux/build -p "Linux Kernel" -v "6.8"

EOF
}

# Parse command line arguments
while getopts "i:o:b:p:v:h" opt; do
    case $opt in
        i) INPUT_DIR="$OPTARG" ;;
        o) OUTPUT_DIR="$OPTARG" ;;
        b) BUILD_DIR="$OPTARG" ;;
        p) PROJECT_NAME="$OPTARG" ;;
        v) PROJECT_VERSION="$OPTARG" ;;
        h) show_help; exit 0 ;;
        *) echo "Invalid option. Use -h for help."; exit 1 ;;
    esac
done

# Validate inputs
if [[ -z "$INPUT_DIR" ]]; then
    echo "Error: Input directory must be specified with -i option."
    exit 1
fi

if [[ -z "$OUTPUT_DIR" ]]; then
    echo "Error: Output directory must be specified with -o option."
    exit 1
fi

if [[ -z "$BUILD_DIR" ]]; then
    echo "Error: Build directory must be specified with -b option."
    exit 1
fi

if [[ -z "$PROJECT_NAME" ]]; then
    echo "Error: Project name must be specified with -p option."
    exit 1
fi

if [[ -z "$PROJECT_VERSION" ]]; then
    echo "Error: Project version must be specified with -v option."
    exit 1
fi

if [[ ! -d "$INPUT_DIR" ]]; then
    echo "Error: Input directory '$INPUT_DIR' does not exist."
    exit 1
fi

if [[ ! -f "$BUILD_DIR/compile_commands.json" ]]; then
    echo "Error: compile_commands.json not found in '$BUILD_DIR'."
    echo "Please build the kernel with 'make LLVM=1' to generate compile_commands.json."
    exit 1
fi

# Create output directory with project name and version subdirectory
FINAL_OUTPUT_DIR="$OUTPUT_DIR/$PROJECT_NAME:$PROJECT_VERSION"
mkdir -p "$FINAL_OUTPUT_DIR"

echo "Starting codebrowser generation..."
echo "Input: $INPUT_DIR"
echo "Output: $OUTPUT_DIR"
echo "Final Output: $FINAL_OUTPUT_DIR"
echo "Build: $BUILD_DIR"
echo "Project: $PROJECT_NAME"
echo "Version: $PROJECT_VERSION"

# Run codebrowser generator
codebrowser_generator \
    -a \
    -o "$FINAL_OUTPUT_DIR" \
    -b "$BUILD_DIR" \
    -p "$PROJECT_NAME:$PROJECT_VERSION:$INPUT_DIR"

# Generate index
if command -v codebrowser_indexgenerator &> /dev/null; then
    echo "Generating index..."
    codebrowser_indexgenerator "$INPUT_DIR"
else
    echo "Warning: codebrowser_indexgenerator not found. Index will not be generated."
fi

# Copy data directory to output directory
if [[ -d "/usr/local/share/codebrowser-data" ]]; then
    echo "Copying data directory to output..."
    cp -r /usr/local/share/codebrowser-data "$OUTPUT_DIR/data"
    echo "Data directory copied to $OUTPUT_DIR/data"
else
    echo "Warning: Data directory not found at /usr/local/share/codebrowser-data"
fi

echo "Codebrowser generation complete!"
echo "Output directory: $FINAL_OUTPUT_DIR"
