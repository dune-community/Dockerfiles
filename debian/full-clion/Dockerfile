# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Rene Milk (2017)

FROM dunecommunity/dailywork:debian-full-interactive

MAINTAINER René Milk <rene.milk@wwu.de>

RUN apt-get update && \
    apt-get install -yq --no-install-recommends libxext6 libxrender1 libxtst6 libxi6 && \
    apt-get remove -yq qtcreator && \
    mkdir -p /opt/ide && \
    wget -qO- https://download.jetbrains.com/cpp/CLion-2017.1.1.tar.gz | \
        tar zx --strip-components=1 -C /opt/ide && \
    ln -s /opt/ide/bin/clion.sh /usr/local/bin/clion && \
    wget http://ftp.de.debian.org/debian/pool/contrib/f/fonts-firacode/fonts-firacode_1.204-2_all.deb -O /tmp/fira.deb &&\
    dpkg -i /tmp/fira.deb && \
    rm /tmp/fira.deb && \
    mkdir -p /usr/lib/jvm && \
    wget -qO- --no-check-certificate --no-cookies \
         --header "Cookie: oraclelicense=accept-securebackup-cookie" \
         http://download.oracle.com/otn-pub/java/jdk/8u65-b17/jdk-8u65-linux-x64.tar.gz | \
	 tar zx -C /usr/lib/jvm && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV CL_JDK="/usr/lib/jvm/oracle-jdk-8" \
    JDK_HOME="/usr/lib/jvm/jdk1.8.0_65"  \
    JAVA_HOME="/usr/lib/jvm/jdk1.8.0_65" \
    PATH="$PATH:$JAVA_HOME/bin"
