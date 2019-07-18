# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Rene Milk (2017)

NAME = debian
DEBIANVERSION=buster
AUTHOR = rene.milk@wwu.de

include $(dir $(lastword $(MAKEFILE_LIST)))/../rules.mk

UNSTABLES = $(addprefix unstable-,$(patsubst %/,%,$(dir $(wildcard */Dockerfile.in))))
$(UNSTABLES): DEBIANVERSION=unstable
$(UNSTABLES): NAME=debian-unstable
$(UNSTABLES): unstable-% : %
unstable: $(UNSTABLES)

ci = minimal minimal-interactive full clion qtcreator
ci: docs $(ci)
unstable_ci: $(addprefix unstable-,$(ci))
# 'wrong' order to not match implicit included rules
ci_push: $(addprefix push_,$(ci))
unstable_ci_push: $(addprefix push_,$(addprefix unstable-,$(ci)))


.PHONY: $(REPONAMES) $(UNSTABLES)
