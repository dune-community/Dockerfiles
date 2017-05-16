# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Felix Schindler (2017)
#   Rene Milk       (2017)

FROM dunecommunity/dailywork:manylinux-minimal

MAINTAINER Felix Schindler <felix.schindler@wwu.de>

# do not install SuperLU-devel
RUN yum -y install bash-completion blas-devel ccache doxygen gdb lapack-devel openmpi-devel vim-enhanced wget

# we want to have intels tbb
RUN cd /usr/local/src && \
    export ARCH_PKG_ID=packages-caaff3a19588f23c0e5ff145f2762dacc7b2d818 && \
    wget --no-check-certificate https://git.archlinux.org/svntogit/packages.git/snapshot/${ARCH_PKG_ID}.tar.gz && \
    tar -xzf ${ARCH_PKG_ID}.tar.gz && \
    cd ${ARCH_PKG_ID}/trunk && \
    source PKGBUILD && \
    export pkgdir=/opt/${pkgname}-${pkgver} && \
    wget $source && \
    tar -xzf *.tgz && \
    build && \
    cd .. && \
    package && \
    echo 'export LD_LIBRARY_PATH=/opt/intel-tbb-4.2_20140601/usr/lib:$LD_LIBRARY_PATH' > /opt/intel-tbb-4.2_20140601.activate.sh && \
    echo 'export LD_LIBRARY_PATH=${LD_LIBRARY_PATH/\/opt\/intel-tbb-4.2_20140601\/usr\/lib:/}' > /opt/intel-tbb-4.2_20140601.deactivate.sh

RUN echo 'export PATH=/usr/lib64/openmpi/1.4-gcc/bin:$PATH' > /opt/openmpi-1.4.activate.sh && \
    echo 'export LD_LIBRARY_PATH=/usr/lib64/openmpi/1.4-gcc/lib:$LD_LIBRARY_PATH' >> /opt/openmpi-1.4.activate.sh && \
    echo 'export PATH=${PATH/\/usr\/lib64\/openmpi\/1.4-gcc\/bin:/}' > /opt/openmpi-1.4.deactivate.sh && \
    echo 'export LD_LIBRARY_PATH=${LD_LIBRARY_PATH/\/usr\/lib64\/openmpi\/1.4-gcc\/lib:/}' >> /opt/openmpi-1.4.deactivate.sh

RUN mkdir -p /home/user/.ccache && \
    echo "max_size = 5.0G" > /home/user/.ccache/ccache.conf && \
    cd /usr/local/bin && \
    for ii in g++ gcc mpic++ mpicc mpiCC mpicxx; do ln -s $(which ccache) $ii; done

# clean up, there might be some leftovers
RUN yum clean all

