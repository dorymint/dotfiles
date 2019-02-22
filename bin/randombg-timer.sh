#!/bin/sh
set -eu

if systemctl --user is-active randombg.timer > /dev/null; then
  systemctl --user stop loglevel.service randombg.timer randombg.service
  echo "randombg.timer stopped"
else
  systemctl --user start loglevel.service randombg.timer randombg.service
  echo "randombg.timer started"
fi

