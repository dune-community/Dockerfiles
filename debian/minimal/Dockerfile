# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Felix Schindler (2017)
#   Rene Milk       (2017)

# aka debian:9 (released June '17)
FROM debian:stretch

MAINTAINER Felix Schindler <felix.schindler@wwu.de>

ENV DEBIAN_FRONTEND noninteractive

# locale is mainly required for the interactive session
RUN apt-get update && \
    apt-get upgrade -y --no-install-recommends && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen && \
    apt-get install -y --no-install-recommends locales && \
    export LANG=en_US.UTF-8 && \
    dpkg-reconfigure locales

# we require stretch-backports for some packages (see below), but we only allow them in manual installs
# the upgrade should thus be a noop
RUN echo "Package: *" >> /etc/apt/preferences.d/stretch-backports && \
    echo "Pin: release a=stretch-backports" >> /etc/apt/preferences.d/stretch-backports && \
    echo "Pin-Priority: 200" >> /etc/apt/preferences.d/stretch-backports && \
    echo "deb http://httpredir.debian.org/debian stretch-backports main contrib non-free" > /etc/apt/sources.list.d/stretch-backports.list && \
    echo "deb http://httpredir.debian.org/debian/ stretch contrib non-free" > /etc/apt/sources.list.d/stretch-nonfree.list && \
    apt-get update && \
    apt-get upgrade -y --no-install-recommends

# the bare minimum
RUN apt-get update && \
    apt-get install -y --no-install-recommends automake bison build-essential cmake flex gfortran git libboost-system-dev \
                                               libboost-thread-dev libboost-filesystem-dev libboost-date-time-dev \
                                               libboost-timer-dev libboost-chrono-dev libsuperlu-dev libtool \
                                               pkg-config python python-dev python-pip python3 python3-dev \
                                               python3-pip python3-virtualenv unzip virtualenv wget libopenblas-dev \
                                               ca-certificates wget sudo cmake cmake-curses-gui gosu

# clean up, there might be some leftovers
RUN apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install dune_setup_X scripts
RUN git clone https://github.com/dune-community/cli-setup && \
    cd cli-setup && \
    cmake . && make install && cd .. && rm -rf cli-setup

ADD entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

ENV DXT_EXTERNAL_LIBS debian__minimal
