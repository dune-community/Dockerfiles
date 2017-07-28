# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Rene Milk (2017)

FROM dunecommunity/dailywork_debian-full-interactive

MAINTAINER René Milk <rene.milk@wwu.de>

RUN apt-get update && \
    apt-get install -t jessie-backports -yq --no-install-recommends openjdk-8-jdk  && \
    apt-get install -yq --no-install-recommends libxext6 libxrender1 libxtst6 libxi6 && \
    apt-get remove -yq qtcreator && \
    mkdir -p /opt/ide && \
    wget -qO- https://download.jetbrains.com/cpp/CLion-2017.2.tar.gz | \
        tar zx --strip-components=1 -C /opt/ide && \
    ln -s /opt/ide/bin/clion.sh /usr/local/bin/clion && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
