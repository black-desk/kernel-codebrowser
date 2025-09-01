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
    -p "$PROJECT_NAME:$INPUT_DIR:$PROJECT_VERSION"

# Generate index
if command -v codebrowser_indexgenerator &> /dev/null; then
    echo "Generating index..."
    codebrowser_indexgenerator "$OUTPUT_DIR/$PROJECT_NAME:$PROJECT_VERSION" -p "$PROJECT_NAME:$INPUT_DIR:$PROJECT_VERSION" -d data
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

# Generate a simple index.html with links to all generated projects
echo "Creating main index.html..."
INDEX_FILE="$OUTPUT_DIR/index.html"

# Start HTML document
cat > "$INDEX_FILE" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kernel Code Browser</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }
        .project-list {
            list-style-type: none;
            padding: 0;
        }
        .project-item {
            margin: 15px 0;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 5px;
            border-left: 4px solid #007bff;
        }
        .project-link {
            text-decoration: none;
            color: #007bff;
            font-size: 18px;
            font-weight: bold;
        }
        .project-link:hover {
            color: #0056b3;
        }
        .project-path {
            color: #666;
            font-size: 14px;
            margin-top: 5px;
        }
        .footer {
            text-align: center;
            margin-top: 30px;
            color: #666;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Kernel Code Browser</h1>
        <ul class="project-list">
EOF

# Add current project entry
echo "            <li class=\"project-item\">" >> "$INDEX_FILE"
echo "                <a href=\"$PROJECT_NAME:$PROJECT_VERSION/index.html\" class=\"project-link\">$PROJECT_NAME</a>" >> "$INDEX_FILE"
echo "                <div class=\"project-path\">Version: $PROJECT_VERSION</div>" >> "$INDEX_FILE"
echo "            </li>" >> "$INDEX_FILE"

# Close HTML document
cat >> "$INDEX_FILE" << 'EOF'
        </ul>
        <div class="footer">
            <p>Generated by Kernel Code Browser</p>
        </div>
    </div>
</body>
</html>
EOF

echo "Main index.html created at: $INDEX_FILE"
