#!/bin/bash

set -e

cd $HOME
git clone https://github.com/dune-community/dune-gdt-pymor-interaction.git
cd $HOME/dune-gdt-pymor-interaction
git submodule update --init --recursive

export OPTS=gcc-debug
./local/bin/gen_path.py
echo 'export CMAKE_FLAGS="-DCMAKE_PREFIX_PATH=$INSTALL_PREFIX -DEIGEN3_INCLUDE_DIR=$INSTALL_PREFIX/include/eigen3 -DDUNE_XT_WITH_PYTHON_BINDINGS=TRUE"' >> PATH.sh
echo "export OMPI_MCA_orte_rsh_agent=/bin/false" >> PATH.sh
source PATH.sh

./local/bin/download_external_libraries.py
./local/bin/build_external_libraries.py
source PATH.sh

./dune-common/bin/dunecontrol --opts=config.opts/$OPTS --builddir=$INSTALL_PREFIX/../build-$OPTS all

for ii in dune-xt-common dune-xt-grid dune-xt-functions dune-xt-la dune-gdt; do echo "$INSTALL_PREFIX/../build-$OPTS/$ii" > "$(python -c 'from distutils.sysconfig import get_python_lib; print(get_python_lib())')/$ii.pth"; done

