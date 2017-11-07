# This file is part of the dune-community/Dockerfiles project:
#   https://github.com/dune-community/Dockerfiles
# Copyright 2017 dune-community/Dockerfiles developers and contributors. All rights reserved.
# License: Dual licensed as BSD 2-Clause License (http://opensource.org/licenses/BSD-2-Clause)
#      or  GPL-2.0+ (http://opensource.org/licenses/gpl-license)
# Authors:
#   Rene Milk (2017)

FROM dunecommunity/debian-clion as clion
FROM dunecommunity/debian-interactive as interactive
FROM dunecommunity/debian-full

MAINTAINER René Milk <rene.milk@wwu.de>

COPY --from=clion /opt/* /opt/
