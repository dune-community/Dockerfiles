#!/bin/bash

set -e

cd $HOME/parabolic-lrbms-2017-code
export OPTS=gcc-relwithdebinfo
source PATH.sh

nice ionice ./dune-common/bin/dunecontrol --opts=config.opts/$OPTS --builddir=$INSTALL_PREFIX/../build-$OPTS all

