# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Felix Schindler (2017)
#   Rene Milk       (2017)

FROM base/devel

MAINTAINER Felix Schindler <felix.schindler@wwu.de>

# init and update
RUN pacman -Sc --noconfirm && \
    touch /root/.gnupg/dirmngr_ldapservers.conf && \
    dirmngr && \
    pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman-key --refresh-keys && \
    pacman -Syy --noconfirm archlinux-keyring && \
    pacman-key --populate archlinux && \
    pacman-key --refresh-keys && \
    pacman -Syyuu --noconfirm

# locale is mainly required for the interactive session
RUN pacman -S --noconfirm glibc sed && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen && \
    echo "LANG=en_US.UTF-8" > /etc/locale.conf && \
    echo "LC_COLLATE=C" > /etc/locale.conf && \
    echo "LC_ALL=en_US.UTF-8" > /etc/locale.conf && \
    echo "LC_TIME=de_DE.UTF-8" > /etc/locale.conf

# the bare minimum, part 1, (base-devel) is contained in the base/devel image
RUN pacman -S --noconfirm blas boost boost-libs git cmake python2 python python2-virtualenv python-virtualenv sudo unzip wget

# the bare minimum, part 2, python-3.4 superlu suexec (for the interactive session)
RUN useradd -r -s /bin/bash -d /var/aur aur
RUN echo "aur ALL=(ALL) NOPASSWD:/usr/bin/pacman" >> /etc/sudoers
USER aur
RUN cd /tmp && \
    wget --no-check-certificate https://aur.archlinux.org/cgit/aur.git/snapshot/suexec.tar.gz && \
    tar -xzf suexec.tar.gz && \
    cd suexec && \
    makepkg -si --noconfirm
RUN cd /tmp && \
    wget --no-check-certificate https://aur.archlinux.org/cgit/aur.git/snapshot/python34.tar.gz && \
    tar -xzf python34.tar.gz && \
    cd python34 && \
    sed -i 's/openssl-1.0/openssl/g' PKGBUILD && \
    makepkg -si --noconfirm
RUN cd /tmp && \
wget --no-check-certificate https://aur.archlinux.org/cgit/aur.git/snapshot/superlu.tar.gz && \
tar -xzf superlu.tar.gz && \
cd superlu && \
makepkg -si --noconfirm
USER root
RUN sed -i 's;aur ALL=(ALL) NOPASSWD:/usr/bin/pacman;;g' /etc/sudoers && \
    userdel aur && \
    rm -rf /var/aur

RUN cd /usr/local/bin && ln -s $(which su-exec) gosu && ln -s /usr/bin/vendor_perl/ack .

# clean up, there might be some leftovers
RUN pacman -Rns --noconfirm $(pacman -Qtdq) || echo "no orphans present" && \
    pacman -Sc --noconfirm

ADD entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

ENV DXT_EXTERNAL_LIBS arch__minimal
