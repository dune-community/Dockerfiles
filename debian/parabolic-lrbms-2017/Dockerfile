# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Felix Schindler (2017)

FROM dunecommunity/dailywork:debian-minimal-interactive

MAINTAINER Felix Schindler <felix.schindler@wwu.de>

RUN export USERNAME_=user && \
    export UID_=1000 && \
    export GID_=$UID_ && \
    groupadd -g $GID_ $USERNAME_ && \
    useradd -md /home/$USERNAME_ -g $GID_ -s /bin/bash -u $UID_ $USERNAME_ && \
    chown -R $USERNAME_:$GID_ /home/$USERNAME_ && \
    echo "$USERNAME_ ALL=(ALL) NOPASSWD:/usr/bin/apt-get" >> /etc/sudoers && \
    echo "$USERNAME_ ALL=(ALL) NOPASSWD:/usr/bin/apt" >> /etc/sudoers

ADD bashrc /home/user/.bashrc
ADD bash_profile /home/user/.bash_profile
ADD build_everything.sh /home/user/
RUN chown -R user:user /home/user

RUN sudo -H -u user bash -c 'cd && bash build_everything.sh && rm build_everything.sh'

ADD entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

