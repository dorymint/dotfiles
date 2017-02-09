#!/bin/bash
set -e
sed -i -e 's/device ./device 0/' "$HOME/.asoundrc"
# EOF
