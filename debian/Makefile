# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Rene Milk (2017)

minimal-interactive: minimal interactive
minimal-interactive-nvidia: minimal-interactive nvidia
docs: minimal
full: minimal
full-interactive: full interactive
full-interactive-nvidia: full-interactive nvidia
full-clion: full-interactive clion
full-clion-nvidia: full-clion nvidia
full-templight: full-interactive templight

NAME = dailywork_debian

include $(dir $(lastword $(MAKEFILE_LIST)))/../rules.mk

travis: full-clion-nvidia minimal-interactive docs
# 'wrong' order to not match implicit included rules
travis_push: push_full-clion push_full-interactive push_full push_minimal-interactive push_minimal push_docs
