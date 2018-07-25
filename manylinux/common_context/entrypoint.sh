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

exec scl enable rh-python36 -- gosu $USERNAME_ "$@"

