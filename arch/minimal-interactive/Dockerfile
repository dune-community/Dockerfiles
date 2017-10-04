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

RUN echo "" >> /etc/pacman.conf && \
    echo "[aur]" >> /etc/pacman.conf && \
    echo "SigLevel = Optional TrustAll" >> /etc/pacman.conf && \
    echo "Server = http://repos.schindlerfamily.de/arch/aur" >> /etc/pacman.conf && \
    echo "" >> /etc/pacman.conf && \
    echo "[scientific-computing]" >> /etc/pacman.conf && \
    echo "SigLevel = Optional TrustAll" >> /etc/pacman.conf && \
    echo "Server = http://repos.schindlerfamily.de/arch/scientific-computing" >> /etc/pacman.conf && \
    pacman -Syuu --noconfirm && \
    pacman -S --noconfirm ack bash-completion ccache clang38 faenza-icon-theme gdb ninja qt5ct qtcreator42 ttf-ubuntu-font-family vim

RUN mkdir -p /home/user/.ccache && \
    echo "max_size = 5.0G" > /home/user/.ccache/ccache.conf && \
    cd /usr/local/bin && \
    for ii in cc clang clang++ cpp g++ gcc ; do ln -s $(which ccache) $ii; done

# clean up, there might be some leftovers
RUN pacman -Rns --noconfirm $(pacman -Qtdq) || echo "no orphans present" && \
    pacman -Sc --noconfirm

ENV DXT_EXTERNAL_LIBS arch__minimal
