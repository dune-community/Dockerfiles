#!/bin/bash -l
set -e -x

# do not build from dirty git unless DIRTY_BUILD evaluates to true
pushd /io/pymor
if [[ $(git rev-parse --show-toplevel 2>/dev/null) = "$PWD" ]] ; then
    [[ ${DIRTY_BUILD} ]] || git diff --exit-code ':(exclude)setup.cfg'
fi
popd

# Compile wheels
${PYBIN}/pip wheel /io/pymor/ -w ${WHEEL_DIR}/

# Bundle external shared libraries into the wheels
for whl in ${WHEEL_DIR}/pymor*.whl; do
    auditwheel repair --plat ${PLATFORM} $whl -w ${WHEEL_DIR}/
done
