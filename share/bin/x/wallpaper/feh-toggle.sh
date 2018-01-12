#!/bin/sh
set -eu

unset -f helpmsg
helpmsg() {
  cat >&1 <<END
  toggle systemctl --user feh-wallpaper.timer
  -h --help	show this help
  -s --status	show status
END
}

case "${1:-}" in
  -h|-help|--help)helpmsg; exit 0;;
  -s|-status|--status)
    systemctl --user status feh-wallpaper.timer
    systemctl --user list-timers
    exit 0;;
  "");;
  *)echo "unknown option: ${*}"; exit 1;;
esac

if systemctl --user is-active feh-wallpaper.timer &> /dev/null; then
  systemctl --user stop feh-wallpaper.timer
  echo "feh-wallpaper.timer deactivated"
else
  systemctl --user start feh-wallpaper.timer
  sleep 1
  systemctl --user start feh-wallpaper.service
  echo "feh-wallpaper.timer activated"
fi
# EOF
