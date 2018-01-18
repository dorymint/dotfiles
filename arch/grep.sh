#!/bin/sh
set -eu
# cds(change to script directory)
cd "$(dirname "$(readlink -f "${0}")")"
grep -e "${1}" --color=auto --line-number -- *.list
