# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Rene Milk (2017)

FROM dunecommunity/dailywork_debian-full-interactive

MAINTAINER René Milk <rene.milk@wwu.de>

ENV ALLINEA_VERSION=6.1 \
    ALLINEA_LICENCE_FILE=${HOME}/.config/allinea/Licence \
    PATH=/opt/allinea/bin:${PATH}

RUN apt-get update && \
    apt-get install -t jessie-backports -yq --no-install-recommends openjdk-8-jdk  && \
    apt-get install -yq --no-install-recommends libxext6 libxrender1 libxtst6 libxi6 && \
    apt-get remove -yq qtcreator && \
    mkdir -p /opt/ide && \
    wget -qO- https://download.jetbrains.com/cpp/CLion-2017.2.1.tar.gz | \
        tar zx --strip-components=1 -C /opt/ide && \
    ln -s /opt/ide/bin/clion.sh /usr/local/bin/clion && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /tmp/allinea/ && \
    wget -qO- http://content.allinea.com/downloads/allinea-forge-${ALLINEA_VERSION}-Ubuntu-14.04-x86_64.tar \
        | tar x --strip-components=1 -C /tmp/allinea && \
    /tmp/allinea/textinstall.sh --accept-licence  /opt/allinea/ 1> /dev/null && \
    rm -rf /tmp/allinea
