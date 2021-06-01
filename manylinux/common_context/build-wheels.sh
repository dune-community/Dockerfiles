#!/bin/bash -l
set -exu

cd ${DUNE_SRC_DIR}

# why was this here again?
rm -rf dune-uggrid dune-testtools

OPTS=${DUNE_SRC_DIR}/config.opts/manylinux

# sets Python path, etc.
source /usr/local/bin/pybin.sh
export CCACHE_DIR=${WHEEL_DIR}/../cache

cd ${DUNE_SRC_DIR}
./dune-common/bin/dunecontrol --opts=${OPTS} all

for md in xt gdt ; do
  [[ -d dune-${md} ]] && \
    ./dune-common/bin/dunecontrol --only=dune-${md} --opts=${OPTS} make -j $(nproc --ignore 1) bindings
done

mkdir ${WHEEL_DIR}/{tmp,final} -p || true

# Compile wheels
for md in xt gdt ; do
  [[ -d dune-${md} ]] && \
    python -m pip wheel ${DUNE_BUILD_DIR}/dune-${md}/python -w ${WHEEL_DIR}/tmp
done

# Bundle external shared libraries into the wheels
for whl in ${WHEEL_DIR}/tmp/dune*.whl; do
    python -m auditwheel repair --plat ${PLATFORM} $whl -w ${WHEEL_DIR}/final
done
