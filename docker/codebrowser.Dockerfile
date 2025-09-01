# SPDX-FileCopyrightText: 2025 Chen Linxuan <me@black-desk.cn>
#
# SPDX-License-Identifier: MIT

FROM debian:stable

LABEL maintainer="Chen Linxuan <me@black-desk.cn>"
LABEL description="KDAB Codebrowser Generator for kernel source code browsing"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    make \
    cmake \
    git \
    llvm-dev \
    libclang-dev \
    clang \
    lld \
    libclang-cpp-dev \
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
    curl \
    ca-certificates \
    && apt-get autoremove -y \
    && apt-get autoclean

WORKDIR /mnt

RUN git clone https://github.com/KDAB/codebrowser.git && \
    cd codebrowser && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local . && \
    make -j$(nproc) && \
    make install && \
    cp -r data /usr/local/share/codebrowser-data && \
    cd .. && \
    rm -rf codebrowser

COPY docker/scripts/generate-codebrowser.sh /mnt/scripts/
RUN chmod +x /mnt/scripts/generate-codebrowser.sh

RUN mkdir -p /mnt/input /mnt/output

CMD ["/bin/bash"]
