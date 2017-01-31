```
  This file is part of the dune-community/Dockerfiles project:
    https://github.com/dune-community/Dockerfiles
  Copyright 2010-2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
  License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
       or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
  Authors:
    Felix Schindler (2017)
```

# docker for DUNE

The idea is to checkout the repository (to work on) on the host and to have a config (as in: `.config`) for the guest system, which are both mounted into the container.
The container is started with X forwarding to allow for interactive development.

## preparing the host

* Allow the user to run docker container via sudo, not by adding him to the docker group (see [the Arch wiki](https://wiki.archlinux.org/index.php/Docker#Installation) on that issue).
  Thus make sure your user has sudo rights or ask your local system administrator to add at least add the following to `/etc/sudoers`, where `_USER` is the name of the host user:
```
_USER ALL=(ALL) /usr/bin/docker
```
* We presume that the repository to work on, e.g. [dune-gdt-pymor-interaction](https://github.com-dune-community/dune-gdt-pymor-interaction) is checked out at
```bash
export HOST_REPO_DIR=$HOME/Projects/dune/dune-gdt-pymor-interaction
```
* and that the location for a persistent config is given by
```bash
export HOST_CONFIG_DIR=$HOME/Projects/dune/docker-cfg/debian && \
mkdir -p $HOST_CONFIG_DIR
```

Adapt these locations to you requirements, you may omit the latter if you want to start with a fresh qtcreator each time you run the container.
## creating a container image

For instance the minimal debian one with stuff for interactive development:

* get the repo, enter the right directory

```bash
git clone https://github.com/dune-community/Dockerfiles.git && \
cd docker-for-dune/debian
```

* build the image, `--rm` removes all intermediate layers, `-t` tags the resulting image

```bash
sudo docker build --rm -t dunecommunity/dev:debian-minimal-interactive -f Dockerfile.minimal-interactive .
```

## start the container

* First of all, allow X access for docker by executing as your normal user on the host
```bash
xhost +local:docker
```
  (after working on the container you can disallow X access again by running `xhost -`).

* Start the container:
```bash
sudo docker run -t -i \
  -e LOCAL_UID=$(id -u) -e LOCAL_GID=$(id -g) \
  -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $HOST_REPO_DIR:/home/user/dune-gdt-pymor-interaction \
  -v $HOST_CONFIG_DIR:/home/user/.config \
  dunecommunity/dev:debian-minimal-interactive \
  qtcreator
```
  What happens here is:
  * `-e LOCAL_UID=$(id -u) -e LOCAL_GID=$(id -g)` sets the uid and gid of the user `user` inside the container, to match those of your user on the host.
    This should avoid any problems regarding file access.
  * `-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix` allows docker to share your X
  * `-v $HOST_REPO_DIR:/home/user/dune-gdt-pymor-interaction` mounts the directory `$HOST_REPO_DIR` on the host to the directory `/home/user/dune-gdt-pymor-interaction` within the container
  * `-v $HOST_CONFIG_DIR:/home/user/.config` s.a., this line may be omitted, (see above)
  * `dunecommunity/dev:debian-minimal-interactive` tells docker which container to run
  * `qtcreator` is being executed within the container as user `user` with home `/home/user`
  
  You can exchange the last command to whatever suits you, e.g. to `/bin/bash` in order to obtain an interactive shell within the container
  
If all went well you should be presented with an instance of qtcreator to start working ...

## docker maintenance

### clean up containers

* remove __all__ container:

```bash
for ii in $(docker ps -a | cut -d ' ' -f 1); do [ "$ii" != "CONTAINER" ] && docker rm $ii; done
```

* list images:

```bash
docker images
```

* remove selected images:
```bash
for ii in ...; do docker rmi $ii; done
```
