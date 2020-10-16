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

set -e

USERNAME_=${LOCAL_USER:-user}
UID_=${LOCAL_UID:-1000}
GID_=${LOCAL_GID:-$UID_}

groupadd -o -g $GID_ $USERNAME_
if [ -e /home/$USERNAME_ ] ; then
  useradd -d /home/$USERNAME_ -g $GID_ -s /bin/bash -u $UID_ $USERNAME_
else
  useradd -md /home/$USERNAME_ -g $GID_ -s /bin/bash -u $UID_ $USERNAME_
fi

chown -R $USERNAME_:$GID_ /home/$USERNAME_

echo "$USERNAME_ ALL=(ALL) NOPASSWD:/usr/bin/pacman" >> /etc/sudoers

export LANG=en_US.UTF-8
echo "127.0.0.1 $HOSTNAME" >> /etc/hosts
echo 'cd $HOME' >> /home/$USERNAME_/.bash_profile

if [ "X$@" == "X" ]; then
  exec su-exec $USERNAME_ /bin/bash
else
  exec su-exec $USERNAME_ "$@"
fi

