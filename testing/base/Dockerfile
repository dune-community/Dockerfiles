# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Rene Milk (2017)

FROM dunecommunity/dailywork_debian-full
MAINTAINER rene.milk@wwu.de

ENV HOME=/root
ENV DEBIAN_FRONTEND=noninteractive \
    SUPERDIR=${HOME}/src
# evaluation order dictates this be split in two
ENV PATH=${SUPERDIR}/local/bin:$PATH \
    LD_LIBRARY_PATH=${SUPERDIR}/local/lib64:${SUPERDIR}/local/lib:$LD_LIBRARY_PATH \
    PKG_CONFIG_PATH=${SUPERDIR}/local/lib64/pkgconfig:${SUPERDIR}/local/lib/pkgconfig:${SUPERDIR}/local/share/pkgconfig:$PKG_CONFIG_PATH \
    DUNE_BUILD_DIR=${HOME}/dune_build/ \
    CLANG_FORMAT='/usr/bin/clang-format-3.8' \
    OPT="-O0" \
    DUNE_VENV=${HOME}/venv \
    DUNE_VENV_ACTIVATE=". ${HOME}/venv/bin/activate" \
    PATH=/usr/lib/ccache:${PATH} \
    OPTS=config.opts/travis.ninja \
    GCOV=/usr/bin/gcov \
    SRC_DCTRL=${SUPERDIR}/dune-common/bin/dunecontrol \
    BUILD_CMD="ninja -k 10000 -j 2"
ENV INSTALL_DIR=${HOME}/dune \
    CTEST_OUTPUT_ON_FAILURE=1 \
    DCTL_ARGS="--builddir=${DUNE_BUILD_DIR} "
ENV DBG="${DCTL_ARGS} --opts=${SUPERDIR}/config.opts/travis.ninja"
ENV BLD="${DBG}"


RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
            python-virtualenv python-pytest python-pip \
            python3-virtualenv python3-pytest python3-pip \
            python3-requests openssh-client \
            python-setuptools python3-setuptools  \
            lcov git  wget unzip curl \
            rsync doxygen texlive-latex-base doxygen-latex && \
    pip3 install -U requests virtualenv cpp-coveralls && \
    pip install -U requests virtualenv cpp-coveralls && \
    mkdir -p ~/.ssh/ && ssh-keyscan -H github.com >> ~/.ssh/known_hosts && \
    git config --global push.default simple

RUN virtualenv --python=python3 ${DUNE_VENV} && \
    ${DUNE_VENV_ACTIVATE} && \
    pip install pytest
ADD entrypoint.bash /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.bash"]
