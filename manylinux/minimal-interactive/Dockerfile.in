# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Felix Schindler (2017)
#   Rene Milk       (2017)

FROM dunecommunity/dailywork_manylinux-minimal

MAINTAINER Felix Schindler <felix.schindler@wwu.de>

RUN yum -y install bash-completion ccache gdb vim-enhanced wget

RUN mkdir -p /home/user/.ccache && \
    echo "max_size = 5.0G" > /home/user/.ccache/ccache.conf && \
    cd /usr/local/bin && \
    for ii in g++ gcc ; do ln -s $(which ccache) $ii; done

# clean up, there might be some leftovers
RUN yum clean all

