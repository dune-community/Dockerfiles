#!/bin/bash

set -e

cd $HOME
git clone https://zivgitlab.uni-muenster.de/falbr_01/parabolic-lrbms-2017-code.git
cd $HOME/parabolic-lrbms-2017-code
git submodule update --init --recursive

export OPTS=gcc-debug
./local/bin/gen_path.py
echo 'export CMAKE_FLAGS="-DCMAKE_PREFIX_PATH=$INSTALL_PREFIX -DDUNE_XT_WITH_PYTHON_BINDINGS=TRUE"' >> PATH.sh
source PATH.sh

