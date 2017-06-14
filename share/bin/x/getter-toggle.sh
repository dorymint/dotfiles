#!/bin/sh
set -eu

unset -f helpmsg
helpmsg() {
  cat >&1 <<END
  -h --help	show this help
  -s --status	show status
END
}

case "${1:-}" in
  "-h"|"--help")helpmsg; exit 0;;
  "-s"|"--status")
    systemctl --user status getter.timer
    systemctl --user list-timers
    exit 0;;
  "");;
  *)echo "unknown option: ${*}"; exit 1;;
esac

if systemctl --user is-active getter.timer &> /dev/null; then
  systemctl --user stop getter.timer
  echo "timer deactivated"
else
  echo "starting getter.service ..."
  systemctl --user start getter.timer
  sleep 1
  systemctl --user start getter.service
  echo "timer activated"
fi
# EOF
