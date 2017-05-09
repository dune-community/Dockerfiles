# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Felix Schindler (2017)
#
#/bin/bash

# see https://hub.docker.com/_/python/, in particular
# https://github.com/docker-library/python/blob/7eca63adca38729424a9bab957f006f5caad870f/3.6/Dockerfile
# we use .tgz instead of .tar.xz (although the latter is smaller), since tar is too old on centos 5

set -ex

source /opt/python-3.6.0.activate.sh
cd /usr/local/src
yum -y install gnupg2 lbzip2-utils ncurses-devel sqlite-devel tcl-devel tk-devel zlib-devel
export LANG=C.UTF-8
export GPG_KEY=0D96DF4D4110E5C43FBFB17F2D347EA6AA65421D
export PYTHON_VERSION=3.6.0
export PYTHON_PIP_VERSION=9.0.1
export PREFIX=/opt/python-$PYTHON_VERSION
wget --no-check-certificate -O python.tgz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tgz"
wget --no-check-certificate -O python.tgz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tgz.asc"
export GNUPGHOME="$(mktemp -d)"
gpg2 --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY"
gpg2 --batch --verify python.tgz.asc python.tgz
rm -rf "$GNUPGHOME" python.tgz.asc
mkdir -p /usr/src/python
tar -xzC /usr/src/python --strip-components=1 -f python.tgz
rm -f python.tgz
cd /usr/src/python
./configure --prefix=$PREFIX --enable-loadable-sqlite-extensions --enable-shared
make -j$(nproc)
make install
ldconfig
if [ ! -e /usr/local/bin/pip3 ]; then
    wget --no-check-certificate -O /tmp/get-pip.py 'https://bootstrap.pypa.io/get-pip.py'
    python3 /tmp/get-pip.py "pip==$PYTHON_PIP_VERSION"
    rm /tmp/get-pip.py
fi
pip3 install --no-cache-dir --upgrade --force-reinstall "pip==$PYTHON_PIP_VERSION"
[ "$(pip list |tac|tac| awk -F '[ ()]+' '$1 == "pip" { print $2; exit }')" = "$PYTHON_PIP_VERSION" ]
yum -y erase gnupg2 ncurses-devel sqlite-devel tcl-devel tk-devel zlib-devel
find /usr/local -depth \( \( -type d -a -name test -o -name tests \) -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \) -exec rm -rf '{}' +
rm -rf /usr/src/python ~/.cache
cd /usr/local/bin
{ [ -e easy_install ] || ln -s easy_install-* easy_install; }
ln -s idle3 idle
ln -s pydoc3 pydoc
ln -s python3 python
ln -s python3-config python-config
pip install virtualenv
pip3 install virtualenv

