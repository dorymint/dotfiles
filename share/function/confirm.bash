#!/bin/bash
# scriptencoding utr-8
# confirm
function confirm() {
  local key=""
  local count=0
  while [[ "$key" != "yes" ]] && [[ "$key" != "y" ]]; do
    if [[ "$key" = "no" ]] || [[ "$key" = "n" ]] || [[ $count -gt 2 ]]; then
      echo "stop process"
      exit 1
    fi
    count=$(expr $count + 1)

    echo "$1"
    read key
  done
  return 0
}
# EOF