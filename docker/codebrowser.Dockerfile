# SPDX-FileCopyrightText: 2025 Chen Linxuan <me@black-desk.cn>
#
# SPDX-License-Identifier: MIT

FROM debian:stable

LABEL maintainer="Chen Linxuan <me@black-desk.cn>"
LABEL description="KDAB Codebrowser Generator for kernel source code browsing"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    llvm-dev \
    libclang-dev \
    clang \
    libclang-cpp-dev \
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
    cd .. && \
    rm -rf codebrowser

COPY docker/scripts/generate-codebrowser.sh /mnt/scripts/
RUN chmod +x /mnt/scripts/generate-codebrowser.sh

RUN mkdir -p /mnt/input /mnt/output

CMD ["/bin/bash"]
