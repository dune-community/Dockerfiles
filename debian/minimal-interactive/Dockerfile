# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Felix Schindler (2017)
#   Rene Milk       (2017)

FROM dunecommunity/dailywork_debian-minimal

MAINTAINER Felix Schindler <felix.schindler@wwu.de>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends bash-completion ccache libc++1 clang-3.9 clang-format-3.9 gdb ninja-build \
                    qtcreator time valgrind vim-nox && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.9 100 && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.9 100 && \
    echo ' . /usr/share/bash-completion/bash_completion ' >>  /etc/bash.bashrc

RUN mkdir -p /home/user/.ccache && \
    echo "max_size = 5.0G" > /home/user/.ccache/ccache.conf && \
    cd /usr/local/bin && \
    for ii in cc clang clang++ clang-3.9 clang++-3.9 cpp-6 g++ g++-6 gcc ; do ln -s $(which ccache) $ii; done

RUN cd /tmp && \
    wget http://de.archive.ubuntu.com/ubuntu/pool/main/u/ubuntu-font-family-sources/ttf-ubuntu-font-family_0.80-0ubuntu2_all.deb && \
    dpkg -i ttf-ubuntu-font-family_0.80-0ubuntu2_all.deb && \
    rm ttf-ubuntu-font-family_0.80-0ubuntu2_all.deb

# clean up, there might be some leftovers
RUN apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#libclang python bindings cannot find this on their own
ENV DXT_LIBCLANG_SO /usr/lib/llvm-3.9/lib/libclang.so.1
