#!/bin/sh
set -eu
cd "$(dirname "$(readlink -f "$0")")"
[ -d "./new" ]
cp -i ./new/zshrc.grml ./new/zshrc.grml.local  ./
# EOF
