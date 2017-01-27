#!/bin/bash

UID_=${LOCAL_UID:-1000}
GID_=${LOCAL_GID:-$UID_}

groupadd -g $GID_ user &> /dev/null
if [ -e /home/user ] ; then
  useradd -d /home/user -g $GID_ -s /bin/bash -u $UID_ user
else
  useradd -md /home/user -g $GID_ -s /bin/bash -u $UID_ user
fi

chown -R user:$GID_ /home/user

echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

export LANG=en_US.UTF-8

exec gosu user "$@"

