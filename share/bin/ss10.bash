#!/bin/bash
set -eu
for x in `seq 10`; do ss -a && echo "$x" && sleep 1; done
# EOF
