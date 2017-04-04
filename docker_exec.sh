#!/bin/bash

if (( "$#" < 3 )); then
  echo ""
  echo "usage: ${0}  CONTAINER  PROJECT  LIST_OF_COMMANDS"
  echo ""
  exit 1
fi

export BASEDIR=$PWD
export CONTAINER=${1}
export SYSTEM=${CONTAINER%%-*}
export PROJECT=${2}
shift 2
export CID_FILE=${BASEDIR}/.${PROJECT}-${SYSTEM}-${CONTAINER}.cid

sudo docker exec -it $(cat ${CID_FILE}) gosu $USER "${@}"

