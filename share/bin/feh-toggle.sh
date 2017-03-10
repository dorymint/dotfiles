#!/bin/sh
set -eu

unset -f helpmsg
helpmsg() {
  cat >&1 <<END
  toggle systemctl --user feh-wallpaper.timer
END
}

case "${1:-}" in
  "-h"|"--help") helpmsg; exit 0;;
esac

if systemctl --user is-active feh-wallpaper.timer &> /dev/null; then
  systemctl --user stop feh-wallpaper.timer
  echo "feh-wallpaper.timer deactivated"
else
  systemctl --user start feh-wallpaper.timer feh-wallpaper.service
  echo "feh-wallpaper.timer activated"
fi
# EOF
