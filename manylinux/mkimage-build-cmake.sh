#!/bin/bash
#
# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Felix Schindler (2017)

set -ex

cd /usr/local/src/
wget --no-check-certificate https://cmake.org/files/v3.7/cmake-3.7.2.tar.gz
tar -xzf cmake-3.7.2.tar.gz
cd cmake-3.7.2
./bootstrap --prefix=/opt/cmake-3.7.2
make
make install
cd && rm -rf /usr/local/src/cmake-3.7.2*

