#!/bin/bash
set -eu

service=vboxheadless.service
systemctl --user show $service &> /dev/null

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
  "-s"|"--status")
    systemctl --user status ${service}
    echo "--- list vms ---"
    vboxmanage list vms
    cat "$HOME"/local/currentvm
    echo "--- bind ports ---"
    # maybe deprecation, bug: case currentvm=foo=bar
    vboxmanage showvminfo "$(cat "$HOME"/local/currentvm | cut -d "=" -f 2)" | \
      grep NIC
    exit 0 ;;
  "-n"|"--name")
    shift
    if [ -z "${1:-}" ]; then
      cat "$HOME"/local/currentvm
      exit 0
    fi
    systemctl --user is-active $service 1> /dev/null && exit 2
    echo "currentvm=${1}" > "$HOME"/local/currentvm;;
  "");;
  *)  cat <<END
--- invalid argument ---
$*
END
    exit 1 ;;
esac
unset -f helpmsg

if systemctl --user is-active $service &> /dev/null; then
  echo "please wait for stop VM process"
  which "fortune" &> /dev/null && fortune -a
  systemctl --user stop $service
  echo "inactivate"
else
  systemctl --user start $service
  echo "activate"
  which "fortune" &> /dev/null && fortune -a
fi
# EOF
