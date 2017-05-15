# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Felix Schindler (2017)

FROM pritunl/archlinux:latest

MAINTAINER Felix Schindler <felix.schindler@wwu.de>

# init and update
RUN pacman -Syy && \
    pacman -S --noconfirm archlinux-keyring && \
    pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -Syyuu --noconfirm

# locale is mainly required for the interactive session
RUN pacman -Syyuu --noconfirm && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen && \
    echo "LANG=en_US.UTF-8" > /etc/locale.conf && \
    echo "LC_COLLATE=C" > /etc/locale.conf && \
    echo "LC_ALL=en_US.UTF-8" > /etc/locale.conf && \
    echo "LC_TIME=de_DE.UTF-8" > /etc/locale.conf

# sudo and gosu are only required for the interactive session
# for gosu see https://github.com/pymor/Dockerfiles/blob/master/base/xenial/Dockerfile.in
RUN set -x && \
    export GOSU_VERSION=1.9 && \
    pacman -S --noconfirm ca-certificates sudo wget && \
    export dpkgArch=amd64 && \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" && \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" && \
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu && \
    rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc && \
    chmod +x /usr/local/bin/gosu && \
    gosu nobody true && \
    pacman -Rsc --noconfirm ca-certificates

# the bare minimum
RUN pacman -S --noconfirm boost boost-libs base-devel git cmake python2 python python2-virtualenv python-virtualenv unzip wget

# clean up, there might be some leftovers
RUN pacman -Rns --noconfirm $(pacman -Qtdq) || echo "no orphans present" && \
    rm -rf /var/cache/pacman/pkg/*

ADD entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

