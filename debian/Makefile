# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Rene Milk (2017)

NAME = debian
DEBIANVERSION=stretch
AUTHOR = rene.milk@wwu.de

include $(dir $(lastword $(MAKEFILE_LIST)))/../rules.mk

UNSTABLES = $(addprefix unstable-,$(patsubst %/,%,$(dir $(wildcard */Dockerfile.in))))
$(UNSTABLES): DEBIANVERSION=unstable
$(UNSTABLES): NAME=debian-unstable
$(UNSTABLES): unstable-% : %
unstable: $(UNSTABLES)

TRAVIS = minimal-interactive full minimal full-interactive full-clion full-clion-nvidia full-interactive-nvidia minimal-interactive-nvidia
travis: docs $(TRAVIS)
unstable_travis: $(addprefix unstable-,$(TRAVIS))
# 'wrong' order to not match implicit included rules
travis_push: $(addprefix push_,$(TRAVIS))
unstable_travis_push: $(addprefix push_,$(addprefix unstable-,$(TRAVIS)))


.PHONY: $(REPONAMES) $(UNSTABLES)
