#!/bin/bash -l
set -exu

cd ${DUNE_SRC_DIR}
rm -rf dune-uggrid dune-testtools

OPTS=${DUNE_SRC_DIR}/config.opts/manylinux

source /etc/profile.d/pybin.sh
cd ${DUNE_SRC_DIR}
./dune-common/bin/dunecontrol --opts=${OPTS} all
for md in xt gdt xt-data ; do
  ./dune-common/bin/dunecontrol --only=dune-${md} --opts=${OPTS} make bindings
done

# do not build from dirty git unless DIRTY_BUILD evaluates to true
pushd /io/dxt
if [[ $(git rev-parse --show-toplevel 2>/dev/null) = "$PWD" ]] ; then
    [[ ${DIRTY_BUILD} ]] || git diff --exit-code ':(exclude)setup.cfg'
fi
popd

# Compile wheels
for md in xt gdt xt-data ; do
  ./dune-common/bin/dunecontrol --only=dune-${md} --opts=${OPTS} bexec pip wheel python -w ${WHEEL_DIR}/
done

# Bundle external shared libraries into the wheels
for whl in ${WHEEL_DIR}/dune*.whl; do
    auditwheel repair --plat ${PLATFORM} $whl -w ${WHEEL_DIR}/
done
