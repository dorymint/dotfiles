#!/bin/bash
set -e
sed -i -e 's/device ./device 3/' "$HOME/.asoundrc"
# EOF
