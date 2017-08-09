# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Rene Milk (2017)

REPONAMES = $(patsubst %/,%,$(dir $(wildcard */Dockerfile)))
BRANCH=$(shell git symbolic-ref --short HEAD)
ifeq ($(BRANCH),master)
        PREFIX=""
else
        PREFIX=$(BRANCH)_
endif

.PHONY: push all $(REPONAMES)

$(REPONAMES):
	docker build --rm -t dunecommunity/$(PREFIX)$(NAME)-$@ $@
	docker build --rm -t dunecommunity/$(PREFIX)$(NAME)-$@:$(shell git describe --tags --dirty --always --long) $@

push_%: %
	docker push dunecommunity/$(PREFIX)$(NAME)-$<

push: $(addprefix push_,$(REPONAMES))

all: $(REPONAMES)

.DEFAULT_GOAL := all
