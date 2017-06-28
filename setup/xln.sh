#!/bin/sh
set -eu
lnopt="-sn "
# for accept override
[ "${1:-}" == "-f" ] && lnopt="${lnopt}-f "
set +e
ln $lnopt "$HOME"/dotfiles/x/xinitrc "$HOME"/.xinitrc
ln $lnopt "$HOME"/dotfiles/x/xserverrc "$HOME"/.xserverrc
ln $lnopt "$HOME"/dotfiles/x/Xresources "$HOME"/.Xresources
ln $lnopt "$HOME"/dotfiles/i3/ "$HOME"/.i3
ln $lnopt "$HOME"/dotfiles/termite/ "$HOME"/.config/termite
set -e
# EOF
