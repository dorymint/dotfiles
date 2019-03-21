#!/bin/sh
set -eu
[ -x /usr/local/bin/brightness ] && sudo /usr/local/bin/brightness "$@"
