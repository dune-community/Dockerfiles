#!/bin/sh

PYVER=$(python -c 'pyversions={"3.9":"cp39-cp39","3.8":"cp38-cp38","3.7":"cp37-cp37m", "3.5":"cp35-cp35m", "3.6":"cp36-cp36m"}\
    ;import os;print(pyversions[os.environ["PYTHON_VERSION"]])')
export PYVER
PYTHON_ROOT_DIR=/opt/python/${PYVER}
export PYTHON_ROOT_DIR
PYBIN=${PYTHON_ROOT_DIR}/bin
export PATH=${PYBIN}:${PATH}
