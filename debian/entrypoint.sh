#!/bin/bash

USERNAME_=${LOCAL_USER:-user}
UID_=${LOCAL_UID:-1000}
GID_=${LOCAL_GID:-$UID_}

groupadd -g $GID_ $USERNAME_ &> /dev/null
if [ -e /home/$USERNAME_ ] ; then
  useradd -d /home/$USERNAME_ -g $GID_ -s /bin/bash -u $UID_ $USERNAME_
else
  useradd -md /home/$USERNAME_ -g $GID_ -s /bin/bash -u $UID_ $USERNAME_
fi

chown -R $USERNAME_:$GID_ /home/$USERNAME_

echo "$USERNAME_ ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

export LANG=en_US.UTF-8

exec gosu $USERNAME_ "$@"

