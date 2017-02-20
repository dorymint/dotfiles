#!/bin/bash
set -eu
cd "$1"
for x in *; do unlink "$x"; done
# EOF
