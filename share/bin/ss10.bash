#!/bin/bash
set -eu
for x in `seq 100`; do ss -a && echo "$x" && sleep 3; done
# EOF
