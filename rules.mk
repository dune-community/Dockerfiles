# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Rene Milk (2017)

THISDIR=$(dir $(lastword $(MAKEFILE_LIST)))

REPONAMES = $(patsubst %/,%,$(dir $(wildcard */Dockerfile.in)))
DOCKER_NOCACHE=
BUILD_CMD=$(DOCKER_SUDO) docker build ${DOCKER_NOCACHE} --rm=true ${DOCKER_QUIET}

.PHONY: push all $(REPONAMES) readme

BRANCH=rene_lrbms

check_client:
	@$(DOCKER_SUDO) docker info > /dev/null  || \
	  (echo "cannot connect to docker client. export DOCKER_SUDO=sudo ?" ; exit 1)

$(REPONAMES): check_client
	$(eval GITREV=$(shell git describe --tags --dirty --always --long))
	$(eval IMAGE=$(NAME)-$@)
	$(eval REPO=dunecommunity/$(IMAGE))
	$(eval DF=Dockerfile.generated.$(DEBIANVERSION))
	$(eval CTX=$@_$(DEBIANVERSION)_context.tar)
	tar --create --file $(CTX) -C $@/../common_context .
	m4 -D BUILD_DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ") \
		-D IMAGE="$(IMAGE)" \
		-D AUTHOR="$(AUTHOR)" \
		-D GITREV=$(GITREV) \
		-D BRANCHEDGITREV=$(BRANCH)_$(GITREV) \
		-D DEBIANBASEDATE=20200224 \
		-D DEBIANVERSION=$(DEBIANVERSION) \
		-I$(THISDIR)/include -I ./include $@/Dockerfile.in > $@/$(DF)
	(test -n "${DOCKER_PRUNE}" && docker system prune -f) || true
	tar --append --file $(CTX) -C $@ .
	cd $@ && cat ../$(CTX) | $(BUILD_CMD) \
		-t $(REPO):$(GITREV) -f $(DF) -
	$(DOCKER_SUDO) docker tag $(REPO):$(GITREV) $(REPO):$(BRANCH)_$(GITREV)
	$(DOCKER_SUDO) docker tag $(REPO):$(GITREV) $(REPO):$(BRANCH)

push_%:
	$(eval GITREV=$(shell git describe --tags --dirty --always --long))
	$(DOCKER_SUDO) docker push dunecommunity/$(NAME)-$*:$(BRANCH)_$(GITREV)
	$(DOCKER_SUDO) docker push dunecommunity/$(NAME)-$*:$(BRANCH)

push: $(addprefix push_,$(REPONAMES))

all: $(REPONAMES)

readme:
	m4 -d -D REPONAMES="$(REPONAMES)" -I$(THISDIR)/include -I ./include \
		-D BASENAME=$(NAME) $(THISDIR)/include/readme.m4 \
	  > README.md
	# emulate autoconf quadrigraphs to escape m4's quoting hell wrt [,]
	sed -i -e 's/@<:@/[/g' -e 's/@>:@/]/g' README.md

.DEFAULT_GOAL := all
