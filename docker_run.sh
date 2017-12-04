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
PROJECT=${2}
shift 2
CID_FILE=${BASEDIR}/.${PROJECT}-${CONTAINER}.cid
PORT="18$(( ( RANDOM % 10 ) ))$(( ( RANDOM % 10 ) ))$(( ( RANDOM % 10 ) ))"
DOCKER_HOME=${BASEDIR}/docker-homes/${SYSTEM}

if [ -e ${CID_FILE} ]; then

  echo "A docker container for"
  echo "  ${PROJECT}"
  echo "  based on dunecommunity/${CONTAINER}"
  echo "is already running. Execute the following command to connect to it"
  echo "(docker_exec.sh is provided alongside this file):"
  echo "  docker_exec.sh ${CONTAINER} ${PROJECT} ${@}"

else

  if systemctl status docker | grep running &> /dev/null; then
    echo -n "Starting "
  else
    echo -n "Starting docker "
    sudo systemctl start docker
    echo -n "and "
  fi

  echo "a docker container"
  echo "  for ${PROJECT}"
  echo "  based on dunecommunity/${CONTAINER}"
  echo "  on port $PORT"

  mkdir -p ${DOCKER_HOME} &> /dev/null

  sudo docker run --rm=true --privileged=true -t -i --hostname docker --cidfile=${CID_FILE} \
    -e LOCAL_USER=$USER -e LOCAL_UID=$(id -u) -e LOCAL_GID=$(id -g) \
    -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e QT_X11_NO_MITSHM=1 \
    -e EXPOSED_PORT=$PORT -p $PORT:$PORT \
    -v /etc/localtime:/etc/localtime:ro \
    -v $DOCKER_HOME:/home/${USER} \
    -v ${BASEDIR}/${PROJECT}:/home/${USER}/${PROJECT} \
    dunecommunity/${CONTAINER} "${@}"

  if [ -d $DOCKER_HOME/${PROJECT} ]; then
    [ "$(ls -A $DOCKER_HOME/${PROJECT})" ] || rmdir $DOCKER_HOME/${PROJECT}
  fi

  rm -f ${CID_FILE}

fi
