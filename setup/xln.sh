#!/bin/sh
set -eu
lnopt="-s "
# for accept override
[ "${1:-}" == "-f" ] && lnopt="${lnopt}-f "
set +e
ln $lnopt "$HOME"/dotfiles/x/xinitrc "$HOME"/.xinitrc
ln $lnopt "$HOME"/dotfiles/x/xserverrc "$HOME"/.xserverrc
ln $lnopt "$HOME"/dotfiles/x/Xresources "$HOME"/.Xresources
set -e
# EOF
