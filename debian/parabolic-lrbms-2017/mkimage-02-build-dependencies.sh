#!/bin/bash

set -e

cd $HOME/parabolic-lrbms-2017-code
export OPTS=gcc-debug
source PATH.sh

./local/bin/download_external_libraries.py
./local/bin/build_external_libraries.py

