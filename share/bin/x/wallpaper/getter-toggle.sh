#!/bin/sh
set -eu

unset -f helpmsg
helpmsg() {
  cat >&1 <<END
  -h --help	show this help
  -s --status	show status

  --service	specify name of service unit
  --timer	specify name of timer unit
END
}
while [ -n "${1:-}" ]; do
  case "${1:-}" in
    "-h"|"--help")helpmsg; exit 0;;
    "-s"|"--status")
      systemctl --user status getter.timer
      systemctl --user list-timers
      exit 0;;
    "--service") shift; service="$1";;
    "--timer") shift; timer="$1";;
    "");;
    *)echo "unknown option: ${*}"; exit 1;;
  esac
  shift
done
service=${service:-"getter.service"}
timer=${timer:-"getter.timer"}

if systemctl --user is-active $timer &> /dev/null; then
  systemctl --user stop $timer
  echo "timer deactivated"
else
  echo "starting $service ..."
  systemctl --user start $timer
  sleep 1
  systemctl --user start $service
  echo "timer activated"
fi
# EOF
