#!/bin/sh
set -eu
option="-s "
# for accept override
[ "${1:-}" == "-f" ] && option="${option}-f "
set +e
ln $option "$HOME"/dotfiles/x/xinitrc "$HOME"/.xinitrc
ln $option "$HOME"/dotfiles/x/xserverrc "$HOME"/.xserverrc
ln $option "$HOME"/dotfiles/x/Xresources "$HOME"/.Xresources
set -e
# EOF
