<!--
SPDX-FileCopyrightText: 2025 Chen Linxuan <me@black-desk.cn>

SPDX-License-Identifier: MIT
-->

# Docker Images for Kernel Codebrowser

This directory contains Docker configurations for building and browsing Linux kernel source code using KDAB's codebrowser.

## Quick Start

### Option 1: Use Pre-built Images from GHCR

```bash
# Pull images from GitHub Container Registry
docker pull ghcr.io/black-desk/kernel-codebrowser/kernel-build:latest
docker pull ghcr.io/black-desk/kernel-codebrowser/codebrowser:latest

# Use the images directly
docker run -it --rm \
  -v $(pwd)/linux-source:/mnt/input \
  -v $(pwd)/build-output:/mnt/output \
  ghcr.io/black-desk/kernel-codebrowser/kernel-build:latest \
  /mnt/scripts/kernel-build.sh
```

### Option 2: Build Docker Images Locally

```bash
# Build kernel build environment
docker build -f docker/kernel-build.Dockerfile -t kernel-build .

# Build codebrowser generator
docker build -f docker/codebrowser.Dockerfile -t codebrowser .
```

### Generate Kernel Codebrowser

```bash
# 1. Build kernel with compile database (using pre-built image)
docker run -it --rm \
  -v $(pwd)/linux-source:/mnt/input \
  -v $(pwd)/build-output:/mnt/output \
  ghcr.io/black-desk/kernel-codebrowser/kernel-build:latest \
  /mnt/scripts/kernel-build.sh

# 2. Generate codebrowser HTML (using pre-built image)
docker run -it --rm \
  -v $(pwd)/linux-source:/mnt/input \
  -v $(pwd)/build-output:/mnt/build \
  -v $(pwd)/html-output:/mnt/output \
  ghcr.io/black-desk/kernel-codebrowser/codebrowser:latest \
  codebrowser_generator -a -o /mnt/output -b /mnt/build -p "kernel:/mnt/input"
```

### Using Locally Built Images

```bash
# Same commands but with local image names
docker run -it --rm \
  -v $(pwd)/linux-source:/mnt/input \
  -v $(pwd)/build-output:/mnt/output \
  kernel-build \
  /mnt/scripts/kernel-build.sh
```

## Available Images

The following pre-built images are available on GitHub Container Registry:

- `ghcr.io/black-desk/kernel-codebrowser/kernel-build:latest` - Linux kernel build environment with Clang/LLVM
- `ghcr.io/black-desk/kernel-codebrowser/codebrowser:latest` - KDAB codebrowser generator environment

Images are automatically built and updated:

- On every push to master branch
- Weekly on Sundays to pick up base image security updates
- Manually via GitHub Actions workflow dispatch

## Directory Structure

- `codebrowser.Dockerfile` - KDAB codebrowser generator environment
- `kernel-build.Dockerfile` - Linux kernel build environment with Clang/LLVM
- `scripts/` - Helper scripts for common tasks
- `README.md` - This documentation

## Helper Scripts

Both containers include helper scripts in `/mnt/scripts/`:

- `kernel-build.sh` - Simplified kernel building with proper flags
- `generate-codebrowser.sh` - Automated codebrowser generation

## Notes

- Kernel must be built with `LLVM=1` for codebrowser compatibility
- The `compile_commands.json` file is generated automatically during kernel build
- Generated HTML files can be served with any web server
