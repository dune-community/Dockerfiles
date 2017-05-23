# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Felix Schindler (2017)
#   Rene Milk       (2017)

FROM dunecommunity/dailywork_arch-minimal

MAINTAINER Felix Schindler <felix.schindler@wwu.de>

RUN cd /tmp && \
    wget http://repos.schindlerfamily.de/manjaro/scientific-computing/clang38-3.8.1-2-x86_64.pkg.tar.xz http://repos.schindlerfamily.de/manjaro/scientific-computing/llvm-libs38-3.8.1-2-x86_64.pkg.tar.xz && \
    pacman --noconfirm -U clang38-3.8.1-2-x86_64.pkg.tar.xz llvm-libs38-3.8.1-2-x86_64.pkg.tar.xz && \
    rm clang38-3.8.1-2-x86_64.pkg.tar.xz llvm-libs38-3.8.1-2-x86_64.pkg.tar.xz
RUN pacman -Syyuu --noconfirm && \
    pacman -S --noconfirm ack bash-completion ccache faenza-icon-theme gdb ninja ttf-ubuntu-font-family qt5ct qtcreator vim

RUN mkdir -p /home/user/.ccache && \
    echo "max_size = 5.0G" > /home/user/.ccache/ccache.conf && \
    cd /usr/local/bin && \
    for ii in cc clang clang++ cpp g++ gcc ; do ln -s $(which ccache) $ii; done

# clean up, there might be some leftovers
RUN pacman -Rns --noconfirm $(pacman -Qtdq) || echo "no orphans present" && \
    pacman -Sc --noconfirm

