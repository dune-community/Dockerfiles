# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Rene Milk (2017)

NAME = legacy
AUTHOR = rene.milk@wwu.de

include $(dir $(lastword $(MAKEFILE_LIST)))/../rules.mk

SUBDIRS = dune-fem-navier-stokes

.PHONY: subdirs $(SUBDIRS) base push 

subdirs: $(SUBDIRS)

$(SUBDIRS):
	cd $@ && docker build -t dunecommunity/legacy-$@ .

push: push_dune-fem-navier-stokes

push_%: %
	docker push dunecommunity/legacy_$<

all: subdirs

dockerignore:
	find . -mindepth 2 -name .dockerignore  | xargs -I{} cp -f .dockerignore {}


.PHONY: $(SUBDIRS) push dockerignore
