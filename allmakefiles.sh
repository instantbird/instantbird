#! /bin/sh
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# allmakefiles.sh - List of all makefiles.
#   Appends the list of makefiles to the variable, MAKEFILES.
#   There is no need to rerun autoconf after adding makefiles.
#   You only need to run configure.

MAKEFILES=""

# add_makefiles - Shell function to add makefiles to MAKEFILES
add_makefiles() {
  MAKEFILES="$MAKEFILES $*"
}

if [ "$srcdir" = "" ]; then
  srcdir=.
fi

#
# Common makefiles used by everyone
#
add_makefiles "
Makefile
config/autoconf.mk
"

. "${srcdir}/chat/makefiles.sh"
. "${srcdir}/purple/makefiles.sh"

#
# Application-specific makefiles
#
if test -f "${srcdir}/${MOZ_BUILD_APP}/makefiles.sh"; then
  . "${srcdir}/${MOZ_BUILD_APP}/makefiles.sh"
fi
