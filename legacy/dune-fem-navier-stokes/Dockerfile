# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Rene Milk       (2017)

# aka debian:9 (released May '13)
FROM debian:wheezy

ENV DEBIAN_FRONTEND=noninteractive \
    DXT_ENVIRONMENT=legacy \
    CLANG_VERSION=3.9 \
    GCC_VERSION=6 \
    DXT_DOCKER=1

# we require wheezy-backports for some packages (see below), but we only allow them in manual installs
# the upgrade should thus be a noop
# locale is mainly required for the interactive session
RUN apt-get update -qq 1> /dev/null && \
    apt-get upgrade -qqy --no-install-recommends 1> /dev/null && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen && \
    apt-get install -q=100 -y --no-install-recommends locales 1> /dev/null && \
    export LANG=en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    echo 'APT::Default-Release "wheezy";' > /etc/apt/apt.conf.d/default-release && \
    echo "deb http://deb.debian.org/debian wheezy-backports main contrib non-free" > /etc/apt/sources.list.d/wheezy-backports.list && \
    echo "deb http://deb.debian.org/debian/ wheezy contrib non-free" > /etc/apt/sources.list.d/wheezy-nonfree.list && \
    apt-get update -qq 1> /dev/null && \
    apt-get install -q=100 -y --no-install-recommends -t wheezy-backports && \
    apt-get install -q=100 -y --no-install-recommends automake bison build-essential cmake flex gfortran git libboost-system-dev \
                libboost-thread-dev libboost-filesystem-dev libboost-date-time-dev \
                libboost-timer-dev libboost-chrono-dev autoconf automake libtool \
                pkg-config python python-dbg python-dev libgraphviz-dev python-tk \
                python-pip python-virtualenv unzip wget libopenblas-dev \
                g++ gcc gfortran \
                ca-certificates ca-certificates-java wget sudo cmake cmake-curses-gui 1> /dev/null && \

    apt-get autoremove -y 1> /dev/null && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN cd /tmp && git clone https://github.com/dune-community/cli-setup && \
    cd cli-setup && \
    cmake . && make install && rm -rf /tmp/cli-setup


ADD entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

    
# LIBCPP_DEV is defined in include/minimal because older packages were not versioned
RUN apt-get update -qq 1> /dev/null && \
    apt-get install -q=100 -y --no-install-recommends doxygen \
        libalberta-dev libeigen3-dev libscotchmetis-dev libscotchparmetis-dev libsuitesparse-dev \
        libmumps-scotch-dev lcov curl \
        libopenmpi-dev openmpi-common openmpi-bin \
        liblpsolve55-dev liblapacke-dev ssh 1> /dev/null && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD gosu /usr/local/bin/
RUN chmod +x /usr/local/bin/gosu

# see http://label-schema.org/rc1/#build-time-labels
LABEL org.label-schema.build-date=2018-11-20T08:52:42Z \
          org.label-schema.name=debian-full \
          org.label-schema.maintainer=rene.fritze@wwu.de \
          org.label-schema.description="Dev setup for dune modules" \
          org.label-schema.url="https://github.com/dune-community" \
          org.label-schema.vcs-ref=be8daf2-dirty \
          org.label-schema.vcs-url="https://github.com/dune-community/Dockerfiles" \
          org.label-schema.schema-version="1.0" \
          org.label-schema.usage="https://github.com/dune-community/Dockerfiles/blob/master/README.md"

