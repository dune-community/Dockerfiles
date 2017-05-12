#!/bin/bash
#
# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Felix Schindler (2017)

if (( "$#" < 3 )); then
  echo ""
  echo "usage: ${0}  CONTAINER  PROJECT  LIST_OF_COMMANDS"
  echo ""
  exit 1
fi

export BASEDIR=${PWD}
export CONTAINER=${1}
export SYSTEM=${CONTAINER%%-*}
export PROJECT=${2}
shift 2
export CID_FILE=${BASEDIR}/.${PROJECT}-${SYSTEM}-${CONTAINER}.cid
export PORT="18$(( ( RANDOM % 10 ) ))$(( ( RANDOM % 10 ) ))$(( ( RANDOM % 10 ) ))"
export DOCKER_HOME=${BASEDIR}/docker-homes/${SYSTEM}

echo "STARTING on port $PORT ..."

sudo systemctl start docker

mkdir -p ${DOCKER_HOME} &> /dev/null

sudo docker run --privileged=true -t -i --hostname docker --cidfile=${CID_FILE} \
  -e LOCAL_USER=$USER -e LOCAL_UID=$(id -u) -e LOCAL_GID=$(id -g) \
  -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e QT_X11_NO_MITSHM=1 \
  -e EXPOSED_PORT=$PORT -p $PORT:$PORT \
  -v /etc/localtime:/etc/localtime:ro \
  -v $DOCKER_HOME:/home/${USER} \
  -v ${BASEDIR}/${PROJECT}:/home/${USER}/${PROJECT} \
  dunecommunity/dailywork:${CONTAINER} "${@}"

if [ -e $DOCKER_HOME/${PROJECT} ]; then
  # only remove it if we are the last ones to use it
  ls ${BASEDIR}/.${PROJECT}-${SYSTEM}-*.cid &> /dev/null || \
    rmdir $DOCKER_HOME/${PROJECT}/${PROJECT}
fi
rm -f ${CID_FILE}

