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
REGISTRY=zivgitlab.wwu.io/ag-ohlberger/dune-community/docker
GITREV?=$(shell git log -1 --pretty=format:"%H")

.PHONY: push all $(REPONAMES) readme IS_DIRTY

IS_DIRTY:
	@cd $(THISDIR) ; \
	git diff-index --quiet HEAD || \
	(git update-index -q --really-refresh && git diff --no-ext-diff --quiet --exit-code) || \
	(git diff --no-ext-diff ; exit 1)

check_client:
	@$(DOCKER_SUDO) docker info > /dev/null  || \
	  (echo "cannot connect to docker client. export DOCKER_SUDO=sudo ?" ; exit 1)

$(REPONAMES): check_client IS_DIRTY
	$(eval IMAGE=$(NAME)-$@)
	$(eval REPO=$(REGISTRY)/$(IMAGE))
	$(eval DF=Dockerfile.generated.$(DEBIANVERSION))
	$(eval CTX=$@_$(DEBIANVERSION)_context.tar)
	@tar --create --file $(CTX) -C $@/../common_context .
	@m4 -D BUILD_DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ") \
		-D IMAGE="$(IMAGE)" \
		-D AUTHOR="$(AUTHOR)" \
		-D GITREV=$(GITREV) \
		-D DEBIANBASEDATE=20210511 \
		-D DEBIANVERSION=$(DEBIANVERSION) \
		-I$(THISDIR)/include -I ./include $@/Dockerfile.in > $@/$(DF)
	(test -n "${DOCKER_PRUNE}" && docker system prune -f) || true
	@tar --append --file $(CTX) -C $@ .
	cd $@ && cat ../$(CTX) | $(BUILD_CMD) \
		-t $(REPO):$(GITREV) -f $(DF) -
	$(DOCKER_SUDO) docker tag $(REPO):$(GITREV) $(REPO):latest

push_%:
	$(DOCKER_SUDO) docker push $(REGISTRY)/$(NAME)-$*

push: $(addprefix push_,$(REPONAMES))

all: $(REPONAMES)

readme:
	m4 -d -D REPONAMES="$(REPONAMES)" -I$(THISDIR)/include -I ./include \
		-D BASENAME=$(NAME) $(THISDIR)/include/readme.m4 \
	  > README.md
	# emulate autoconf quadrigraphs to escape m4's quoting hell wrt [,]
	sed -i -e 's/@<:@/[/g' -e 's/@>:@/]/g' README.md

.DEFAULT_GOAL := all
