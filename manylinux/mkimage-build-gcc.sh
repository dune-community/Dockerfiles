#!/bin/bash
#
# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2010-2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Felix Schindler (2017)

set -ex

cd /tmp
git clone https://github.com/jlinoff/gcc-4.9.1-boost-1.56.git && cd gcc-4.9.1-boost-1.56
mv bld.sh Makefile /opt/
rm -rf /tmp/gcc-4.9.1-boost-1.56
cd /opt
chmod 755 bld.sh
sed -i 's;http://ftp.gnu.org/gnu/gcc/gcc-4.9.1/gcc-4.9.1.tar.bz2;http://ftp.gnu.org/gnu/gcc/gcc-4.9.4/gcc-4.9.4.tar.bz2;' bld.sh
sed -i 's;rtf;gcc-4.9-toolchain;g' bld.sh
sed -i 's;mpfr-3.1.2;mpfr-3.1.5;g' bld.sh
sed -i 's;wget ;wget --no-check-certificate ;g' bld.sh
sed -i '/http:\/\/sourceforge.net\/projects\/boost\/files\/boost/d' bld.sh
sed -i '/boost_\*/,/\;\;/d' bld.sh
make
cd /opt && rm -rf archives rtf src bld logs LOCAL-TEST bld.sh Makefile || echo "removed stuff"

