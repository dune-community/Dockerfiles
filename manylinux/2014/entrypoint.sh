#!/bin/bash

USER_ID=${LOCAL_USER_ID:-1000}
GROUP_ID=${LOCAL_GROUP_ID:-1000}

echo "Starting with UID : $USER_ID"
useradd  --shell /bin/bash -u $USER_ID -o  -m pymor
export HOME=/home/pymor

exec gosu pymor "$@"
