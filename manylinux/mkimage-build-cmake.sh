#!/bin/bash

set -ex

cd /usr/local/src/
wget --no-check-certificate https://cmake.org/files/v3.7/cmake-3.7.2.tar.gz
tar -xzf cmake-3.7.2.tar.gz
cd cmake-3.7.2
./bootstrap --prefix=/opt/cmake-3.7.2
make
make install
cd && rm -rf /usr/local/src/cmake-3.7.2*

