#!/bin/bash
set -eu

service=vboxheadless.service

# help
unset -f helpmsg
helpmsg() {
  cat >&1 <<END
  toggle vboxeadless.service
  
  -h --help
    show this help
  -s --status
    show status ${service}
  -n --name
    modify target VM name
    $HOME/local/currentvm
END
}
case "${1:-}" in
  "-h"|"--help") helpmsg; exit 0 ;;
  "-s"|"--status") systemctl --user status ${service}; exit 0 ;;
  "-n"|"--name")
    systemctl --user is-active $service 1> /dev/null && exit 5
    shift
    [ "${1}" = "" ] && exit 6
    echo "currentvm=${1}" > "$HOME"/local/currentvm ;;
  "");;
  *)  cat <<END
--- invalid argument ---
$*
END
    exit 1 ;;
esac
unset -f helpmsg

systemctl --user show $service &> /dev/null
if systemctl --user is-active $service &> /dev/null; then
  echo "please wait for stop VM process"
  systemctl --user stop $service
  echo "inactivate"
else
  systemctl --user start $service
  echo "activate"
fi
# EOF
