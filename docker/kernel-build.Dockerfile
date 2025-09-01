# SPDX-FileCopyrightText: 2025 Chen Linxuan <me@black-desk.cn>
#
# SPDX-License-Identifier: MIT

# Dockerfile for Linux Kernel Build Environment
# This container provides a complete environment for building Linux kernel source code

FROM debian:stable

LABEL maintainer="Chen Linxuan <me@black-desk.cn>"
LABEL description="Linux kernel build environment with all necessary tools"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    make \
    git \
    curl \
    ca-certificates \
    llvm-dev \
    clang \
    lld \
    bc \
    bison \
    flex \
    libssl-dev \
    libelf-dev \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    kmod \
    cpio \
    python3-dev \
    && apt-get autoremove -y \
    && apt-get autoclean

WORKDIR /mnt

COPY docker/scripts/kernel-build.sh /mnt/scripts/
RUN chmod +x /mnt/scripts/kernel-build.sh

CMD ["/bin/bash"]
