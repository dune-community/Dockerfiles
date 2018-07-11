# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Rene Milk (2017)

NAME = debian
AUTHOR = rene.milk@wwu.de

include $(dir $(lastword $(MAKEFILE_LIST)))/../rules.mk

travis: docs full-clion-nvidia full-interactive-nvidia minimal-interactive-nvidia
# 'wrong' order to not match implicit included rules
travis_push: push_full-clion push_full-interactive push_full push_minimal-interactive push_minimal push_docs
