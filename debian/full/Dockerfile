# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Felix Schindler (2017)
#   Rene Milk       (2017)

FROM dunecommunity/dailywork_debian-minimal

MAINTAINER Felix Schindler <felix.schindler@wwu.de>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends doxygen clang-3.8 clang-format-3.8 clang-tidy-3.8 \
        libeigen3-dev libscotchmetis-dev libscotchparmetis-dev libsuitesparse-dev libtbb-dev \
        ninja-build openmpi-common openmpi-bin && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.8 100 && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.8 100

