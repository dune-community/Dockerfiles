```
# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Felix Schindler (2017)
#   Rene Milk       (2017)
#   Tim Keil        (2017)
```

# docker for daily work with DUNE

This project allows you to run your code in a fixed build environment; it is mainly developed in the context of DUNE, but could be used in other circumstances as well.

## quick start

Presuming you are running some Linux with a `sudo` capable user, the following should get you started:

* Decide on a project directory for this project as well as your DUNE supermodules (needs to be executed only once, adapt this to you situation):

  ```bash
  export PROJECT_ROOT=${HOME}/Projects/dune
  mkdir -p ${PROJECT_ROOT}
  cd ${PROJECT_ROOT}
  ```

* Get this project and link to the relevant scripts (needs to be executed only once):

  ```bash
  git clone https://github.com/dune-community/Dockerfiles.git docker-for-daily-dune
  ln -s docker-for-daily-dune/docker_run.sh
  ln -s docker-for-daily-dune/docker_exec.sh .
  ```

* Allow X access for docker (needs to be executed only once):
  ```bash
  xhost +local:docker
  ```

* Get the actual project you want to work on (this should be a git supermodule containing all DUNE dependencies, as this is all you get wihtin the container), as an example we use the [dune-gdt-pymor-interaction](https://github.com/dune-community/dune-gdt-pymor-interaction) project here (needs to be repeated for each project to work on):

  ```bash
  git clone https://github.com/dune-community/dune-gdt-pymor-interaction.git
  ```

* Start a suitable docker container for this project (this is what you need to do from now on to work on your project):

  ```bash
  ./docker_run.sh debian-minimal-interactive dune-gdt-pymor-interaction /bin/bash
  ```

  This will start a bash shell within the container.
  You will be left with an empty promp, `exit` will get you out of there, `cd` will get you to your home within the container.
  There you should find the mounted project (e.g., `dune-gdt-pymor-interaction`), which you can enter and start your work.

  The `docker_run.sh` command gets three arguments:

  - The first argument is the tag of the docker container to be chosen from the [dunecommunity docker hub page](https://hub.docker.com/r/dunecommunity).
    These images are automatically generated each night, the name of each tag is of the form `SYSTEM-DEPENDENCIES{,-interactive}`, recommended for DUNE is either `debian-minimal-interactive` for serial and `debian-full-interactive` for parallel builds.
  - The second argument is the exact path of the project to be run inside the container.
    In the case of `dune-gdt-pymor-interaction`, you will have access to this (and only this) directory while working within the container.
  - The third argument is the command to be executed within the container, i.e., to start a shell.

* You can also connect to a running container:

  ```bash
  ./docker_exec.sh debian-minimal-interactive dune-gdt-pymor-interaction /bin/bash
  ```

  The `docker_exec.sh` script accepts the same kind of arguments as `docker_run.sh`.

## more information

### persistent home

The `docker_run.sh` command mounts a persistent directory as the home of the user within the container (see below); in the above example `${PROJECT_ROOT}/docker-homes/debian/`.
You can thus create files and customize your shell within the container, i.e. by creating a `.bashrc` and so on within the container or by copying your existing `.bashrc` to the above folder.

### docker_run.sh

The [docker_run.sh](https://github.com/dune-community/Dockerfiles/blob/master/docker_run.sh) script which is used here does several things, by giving the following arguments to docker:

  * `--privileged=true` allows debugging with `gdb`
  * `-e LOCAL_USER=$USER -e LOCAL_UID=$(id -u) -e LOCAL_GID=$(id -g)` sets the user name, the uid and gid of the user inside the container, to match those of your user on the host.
    This should avoid any problems regarding file access (the user name is just eye candy for itneractive sessions).
  * `-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix` allows docker to share your X
  * `-e EXPOSED_PORT=$PORT -p $PORT:$PORT` exposes a random port for this container (e.g., for jupyter notebooks)
  * `-v /etc/localtime:/etc/localtime:ro` aligns the time within the container with the host
  * `-v $DOCKER_HOME:/home/${USER}` mounts the directory `$DOCKER_HOME` on the host to the directory `/home/${USER}` within the container to allow for a persistent home
  * `-v ${BASEDIR}/${PROJECT}:/home/${USER}/${PROJECT}` allows access to the actual code from within the container
  * `dunecommunity/${CONTAINER}` tells docker which container to run

### docker and security

Allow the user to run docker container via sudo, not by adding him to the docker group (see [the Arch wiki](https://wiki.archlinux.org/index.php/Docker#Installation) on that issue).
Thus make sure your user has sudo rights or ask your local system administrator to add at least the following to `/etc/sudoers`, where `_USER_` is the name of your user:
```
_USER_ ALL=(ALL) /usr/bin/docker
```

### installing additional software

You may install additional software within the container; however, it will not be present after restarting the container (this is the whole point of docker, if in doubt read [any of](https://wiki.archlinux.org/index.php/Docker) these [wikis](https://en.wikipedia.org/wiki/Docker_%28software%29)).
The package manager depends on the docker image:
For **debian-** based images, use

* `sudo apt update` to initialize the cache/refresh the list of available software
* `sudo apt upgrade` to update already installed software (usually not required)
* `sudo apt search <name>` to search for software
* `sudo apt install <name>` to install software

For **arch-** based images, use

Since the `apt` cache is empty you need to

* `sudo pacman -Sy` to initialize the cache/refresh the list of available software
* `sudo pacman -Syuu` to update already installed software (usually not required)
* `sudo pacman -Ss <name>` to search for software
* `sudo pacman -S <name>` to install software

## maintanance

### creating a container image

For instance the minimal debian one with stuff for interactive development:

* get the repo

  ```bash
  git clone https://github.com/dune-community/dockerfiles.git docker-for-daily-dune
  ```

* enter the right directory, build the image manually (`-t` tags the resulting image, the tag `:custom-build` can be omitted, defaults to `:latest`)

  ```bash
  cd docker-for-daily-dune/debian/minimal-interactive
  sudo docker build --rm=true --force-rm=true -t dunecommunity/debian-minimal-interactive:custom-build -f Dockerfile .
  ```
  
  or
  
* use make
  
  ```bash
  cd docker-for-daily-dune/
  sudo make debian-minimal-interactive
  ```

### clean up containers

* remove __all__ container:

  ```bash
  for ii in $(docker ps -a | cut -d ' ' -f 1); do [ "$ii" != "CONTAINER" ] && docker rm $ii; done
  ```

* remove __all__ images:
  ```bash
  for ii in $(docker images | awk '{print $3}'); do [ "$ii" != "IMAGE" ] && docker rmi -f $ii; done
  ```
