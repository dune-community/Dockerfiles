#!/bin/bash
#
# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Felix Schindler (2017)
#   Rene Milk       (2017)

if (( "$#" < 3 )); then
  echo ""
  echo "usage: ${0}  CONTAINER  PROJECT  LIST_OF_COMMANDS"
  echo ""
  exit 1
fi

BASEDIR=${PWD}
CONTAINER=${1}
SYSTEM=${CONTAINER%%-*}
if echo $CONTAINER | xargs python -c "import sys; sys.exit('/' in sys.argv[1])" ; then
  # the container name does not have a prefix, assume it is from dunecommunity/
  export CONTAINER="dunecommunity/${CONTAINER}"
fi
PROJECT=${2}
shift 2
CID_FILE=${BASEDIR}/.${PROJECT}-${CONTAINER//\//_}.cid
PORT="18$(( ( RANDOM % 10 ) ))$(( ( RANDOM % 10 ) ))$(( ( RANDOM % 10 ) ))"
DOCKER_HOME=${HOME}/.docker-homes/${SYSTEM}

if [ -e ${CID_FILE} ]; then

  echo "A podman container for"
  echo "  ${PROJECT}"
  echo "  based on ${CONTAINER}"
  echo "is already running. Execute the following command to connect to it"
  echo "(podman_exec.sh is provided alongside this file):"
  echo "  podman_exec.sh ${CONTAINER} ${PROJECT} ${@}"
  echo "If you are 100% sure the container is dead (check with podman ps), you may delete it:"
  echo "  rm ${CID_FILE}"

else

  if command -v podman &> /dev/null; then
    echo "Starting a podman container"
  else
    echo "MISSING podman!"
    exit 1
  fi

  echo "  for ${PROJECT}"
  echo "  based on ${CONTAINER}"
  echo "  on port $PORT"

  mkdir -p ${DOCKER_HOME} &> /dev/null

  podman run --rm=true --privileged=true -t -i --hostname $HOSTNAME --cidfile=${CID_FILE} \
    -e LOCAL_USER=$USER -e LOCAL_UID=$(id -u) -e LOCAL_GID=$(id -g) \
    -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e QT_X11_NO_MITSHM=1 \
    -e QT_SCALE_FACTOR=${QT_SCALE_FACTOR:-1} \
    -e GDK_DPI_SCALE=${GDK_DPI_SCALE:-1} \
    -e EXPOSED_PORT=$PORT -p $PORT:$PORT \
    -v /etc/localtime:/etc/localtime:ro \
    -v $DOCKER_HOME:/home/${USER} \
    -v ${BASEDIR}/${PROJECT}:/home/${USER}/${PROJECT} \
    ${CONTAINER} "${@}"

  rm -f ${CID_FILE}

  if [ -d $DOCKER_HOME/${PROJECT} ]; then
    [ "$(ls -A $DOCKER_HOME/${PROJECT})" ] || rmdir $DOCKER_HOME/${PROJECT}
  fi

fi
