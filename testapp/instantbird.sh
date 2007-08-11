#!/bin/sh

LD_LIBRARY_PATH=libraries/prpl/ exec xulrunner/xulrunner application.ini "$@"
