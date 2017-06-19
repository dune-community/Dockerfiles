# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Felix Schindler (2017)

FROM dunecommunity/dailywork_arch-minimal-interactive

MAINTAINER Felix Schindler <felix.schindler@wwu.de>

RUN pacman -Syyuu --noconfirm && \
    pacman -S --noconfirm less

RUN export USERNAME_=user && \
    export UID_=1000 && \
    export GID_=$UID_ && \
    groupadd -g $GID_ $USERNAME_ && \
    useradd -md /home/$USERNAME_ -g $GID_ -s /bin/bash -u $UID_ $USERNAME_ && \
    chown -R $USERNAME_:$GID_ /home/$USERNAME_ && \
    echo "$USERNAME_ ALL=(ALL) NOPASSWD:/usr/bin/pacman" >> /etc/sudoers

ADD bashrc /home/user/.bashrc
ADD bash_profile /home/user/.bash_profile
ADD mkimage-*.sh /home/user/
RUN chown -R user:user /home/user

USER user
WORKDIR /home/user
ENV LANG en_US.UTF-8
RUN bash mkimage-01-prepare.sh && \
    bash mkimage-02-build-dependencies.sh && \
    bash mkimage-03-build-dune.sh
RUN bash mkimage-04-finalize.sh && \
    rm -f /home/user/mkimage-*.sh

USER root

# clean up, there might be some leftovers
RUN pacman -Rns --noconfirm $(pacman -Qtdq) || echo "no orphans present" && \
    pacman -Sc --noconfirm

ADD entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

