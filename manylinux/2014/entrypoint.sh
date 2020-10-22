#!/bin/bash

USER_ID=${LOCAL_UID:-1000}
USER=${LOCAL_USER:-dxt}
GROUP_ID=${LOCAL_GID:-1000}

echo "Starting with UID : $USER_ID"
groupadd -g ${GROUP_ID} -o ${USER}
useradd  --shell /bin/bash -u $USER_ID -g ${GROUP_ID} -o  -m ${USER}
export HOME=/home/${USER}

exec gosu ${USER} "$@"
