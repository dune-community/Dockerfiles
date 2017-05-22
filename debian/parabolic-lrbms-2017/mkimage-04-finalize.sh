#!/bin/bash

set -e

cd $HOME/parabolic-lrbms-2017-code
export OPTS=gcc-debug
source PATH.sh

for ii in dune-xt-common dune-xt-grid dune-xt-functions dune-xt-la dune-gdt; do echo "$INSTALL_PREFIX/../build-$OPTS/$ii" > "$(python -c 'from distutils.sysconfig import get_python_lib; print(get_python_lib())')/$ii.pth"; done

#for ii in $(find . -name \*.a -o -name \*.so); do [ "X${ii::21}" != "X./local/lib/python3.4" ] && strip $ii ; done

