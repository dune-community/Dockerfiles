# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Felix Schindler (2017)

FROM quay.io/pypa/manylinux1_x86_64

MAINTAINER Felix Schindler <felix.schindler@wwu.de>

# locale is mainly required for the interactive session
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 && \
    localedef -v -c -i de_DE -f UTF-8 de_DE.UTF-8 || \
    echo ""

# sudo and gosu are only required for the interactive session
# for gosu see https://github.com/pymor/Dockerfiles/blob/master/base/xenial/Dockerfile.in
RUN set -x && \
    export GOSU_VERSION=1.9 && \
    yum -y install epel-release && \
    yum -y install sudo wget dpkg gnupg2 && \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
    wget -O /usr/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" && \
    wget -O /tmp/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" && \
    export GNUPGHOME="$(mktemp -d)" && \
    gpg2 --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
    gpg2 --batch --verify /tmp/gosu.asc /usr/bin/gosu && \
    rm -r "$GNUPGHOME" /tmp/gosu.asc && \
    chmod +x /usr/bin/gosu && \
    gosu nobody true

# the bare minimum, part 1 (what we can install from repos)
RUN yum -y install flex git libtool pkgconfig

# the bare minimum, part 2 (we require gcc >= 4.9)
RUN cd /tmp && \
    git clone https://github.com/jlinoff/gcc-4.9.1-boost-1.56.git && cd gcc-4.9.1-boost-1.56 && \
    mv bld.sh Makefile /opt/ && \
    rm -rf /tmp/gcc-4.9.1-boost-1.56 && \
    cd /opt && \
    chmod 755 bld.sh && \
    sed -i 's;http://ftp.gnu.org/gnu/gcc/gcc-4.9.1/gcc-4.9.1.tar.bz2;http://ftp.gnu.org/gnu/gcc/gcc-4.9.4/gcc-4.9.4.tar.bz2;' bld.sh && \
    sed -i 's;rtf;gcc-4.9-toolchain;g' bld.sh && \
    sed -i 's;mpfr-3.1.2;mpfr-3.1.5;g' bld.sh && \
    sed -i 's;wget ;wget --no-check-certificate ;g' bld.sh && \
    sed -i '/http:\/\/sourceforge.net\/projects\/boost\/files\/boost/d' bld.sh && \
    sed -i '/boost_\*/,/\;\;/d' bld.sh && \
    make -j 2 && \\
    cd /opt && rm -rf archives rtf src bld logs LOCAL-TEST bld.sh Makefile || echo "removed stuff" && \
    echo 'export PATH=/opt/gcc-4.9-toolchain/bin:$PATH' > /opt/gcc-4.9-toolchain.activate.sh && \
    echo 'export LD_LIBRARY_PATH=/opt/gcc-4.9-toolchain/lib64:/opt/gcc-4.9-toolchain/lib:$LD_LIBRARY_PATH' >> /opt/gcc-4.9-toolchain.activate.sh && \
    echo 'export PKG_CONFIG_PATH=/opt/gcc-4.9-toolchain/pkgconfig:$PKG_CONFIG_PATH' >> /opt/gcc-4.9-toolchain.activate.sh && \
    echo 'export PATH=${PATH/\/opt\/gcc-4.9-toolchain\/bin:/}' > /opt/gcc-4.9-toolchain.deactivate.sh && \
    echo 'export LD_LIBRARY_PATH=${LD_LIBRARY_PATH/\/opt\/gcc-4.9-toolchain\/lib64:/}' >> /opt/gcc-4.9-toolchain.deactivate.sh && \
    echo 'export LD_LIBRARY_PATH=${LD_LIBRARY_PATH/\/opt\/gcc-4.9-toolchain\/lib:/}' >> /opt/gcc-4.9-toolchain.deactivate.sh && \
    echo 'export PKG_CONFIG_PATH=${PKG_CONFIG_PATH/\/opt\/gcc-4.9-toolchain\/pkgconfig:}' >> /opt/gcc-4.9-toolchain.deactivate.sh && \
    chmod -R g-w /opt/gcc-4.9-toolchain* && \
    chmod -R o-w /opt/gcc-4.9-toolchain*

# the bare minimum, part 3 (we require cmake >= 3.1)
RUN cd /usr/local/src/ && \
    wget --no-check-certificate https://cmake.org/files/v3.7/cmake-3.7.2.tar.gz  && \
    tar -xzf cmake-3.7.2.tar.gz && \
    cd cmake-3.7.2 && \
    ./bootstrap --prefix=/opt/cmake-3.7.2 && \
    make -j 2 && \
    make install && \
    cd && rm -rf /usr/local/src/cmake-3.7.2* && \
    echo 'export PATH=/opt/cmake-3.7.2/bin:$PATH' > /opt/cmake-3.7.2.activate.sh && \
    echo 'export PATH=${PATH/\/opt\/cmake-3.7.2\/bin:/}' > /opt/cmake-3.7.2.deactivate.sh

# create PATH files for all present python versions and install virtualenv
RUN cd /opt/python && \
    for ii in $(ls -d *); do \
      echo "export PATH=/opt/python/$ii/bin:"'$PATH' > /opt/python/${ii}.activate.sh && \
      echo "export LD_LIBRARY_PATH=/opt/$ii/lib:"'$LD_LIBRARY_PATH' >> /opt/python/${ii}.activate.sh && \
      echo "export PKG_CONFIG_PATH=/opt/$ii/lib/pkgconfig:"'$PKG_CONFIG_PATH' >> /opt/python/${ii}.activate.sh && \
      echo 'export PATH=${PATH/\/opt\/python\/'"$ii"'\/bin:/}' > /opt/python/${ii}.deactivate.sh && \
      echo 'export LD_LIBRARY_PATH=${LD_LIBRARY_PATH/\/opt\/'"$ii"'\/lib:/}' >> /opt/python/${ii}.deactivate.sh && \
      echo 'export PKG_CONFIG_PATH=${PKG_CONFIG_PATH/\/opt\/'"$ii"'\/lib\/pkgconfig:/}' >> /opt/python/${ii}.deactivate.sh && \
      source /opt/python/${ii}.activate.sh && \
      pip install virtualenv; \
      source /opt/python/${ii}.deactivate.sh; done

# clean up, there might be some leftovers
RUN yum -y remove dpkg gnupg2 texinfo && \
    yum clean all

ADD entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

