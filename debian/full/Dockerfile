# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Felix Schindler (2017)
#   Rene Milk       (2017)

FROM dunecommunity/debian-minimal

MAINTAINER Felix Schindler <felix.schindler@wwu.de>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends doxygen libc++-dev clang-3.9 clang-format-3.9 clang-tidy-3.9 \
        libalberta-dev libeigen3-dev libscotchmetis-dev libscotchparmetis-dev libsuitesparse-dev libtbb-dev \
        ninja-build openmpi-common openmpi-bin libqhull-dev liblpsolve55-dev liblapacke-dev && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.9 100 && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.9 100

#libclang python bindings cannot find this on their own
ENV DXT_LIBCLANG_SO /usr/lib/llvm-3.9/lib/libclang.so.1

ENV DXT_EXTERNAL_LIBS debian__full
