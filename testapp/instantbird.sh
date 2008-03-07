#!/bin/sh

cd -P -- "$(dirname -- "$0")"
LD_LIBRARY_PATH=libraries/prpl/ exec xulrunner/xulrunner application.ini "$@"
