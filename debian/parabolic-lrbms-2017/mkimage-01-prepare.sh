#!/bin/bash

set -e

cd $HOME
git clone https://zivgitlab.uni-muenster.de/falbr_01/parabolic-lrbms-2017-code.git
cd $HOME/parabolic-lrbms-2017-code
for ii in config.opts dune-alugrid dune-common dune-fem dune-gdt dune-geometry dune-grid dune-istl dune-pybindxi dune-python dune-testtools dune-xt-common dune-xt-functions dune-xt-grid dune-xt-la local/bin; do git submodule update --init --recursive $ii; done

export OPTS=gcc-debug
./local/bin/gen_path.py
echo 'export CMAKE_FLAGS="-DCMAKE_PREFIX_PATH=$INSTALL_PREFIX -DDUNE_XT_WITH_PYTHON_BINDINGS=TRUE"' >> PATH.sh
source PATH.sh

