#!/bin/bash
set -eu

# TODO: consider

echo "exit"
exit 1

service=vboxheadless.service
if ! systemctl --user cat $service &> /dev/null; then
  echo "not found: systemctl --user $service"
  exit 1
fi

# confirm $1=msg return bool
confirm() {
  local key=""
  local counter=0
  while [ $counter -lt 3 ]; do
    counter=$(( counter + 1 ))
    printf "%s" "$1 [yes:no]?>"
    read -r key || return 1
    case "$key" in
      no|n) return 1;;
      yes|y) return 0;;
    esac
  done
  return 1
}

# help
unset -f helpmsg
helpmsg() {
  cat >&1 <<END
vm-toggle.sh
  toggle for vboxheadless.service

options:
  -h --help
    show this help
  -s --status
    show status ${service}
  -n --name
    modify target VM name
    $HOME/dotfiles/etc/systemd/currentvm
END
}
case "${1:-}" in
  -help|--help|-h)
    helpmsg
    exit 0
    ;;
  -status|--status|-s)
    echo "----- STATUS -----"
    systemctl --user status ${service} || true
    echo "----- LIST VMS -----"
    vboxmanage list vms
    echo "currentvm=$(cat "$HOME"/dotfiles/etc/systemd/currentvm)"
    echo "----- BIND PORTS -----"
    vboxmanage showvminfo "$(cat "$HOME"/dotfiles/etc/systemd/currentvm)" | grep NIC
    exit 0
    ;;
  -name|--name|-n)
    shift
    if [ -z "${1:-}" ]; then
      cat "$HOME"/dotfiles/etc/systemd/currentvm
      exit 0
    fi
    systemctl --user is-active $service 1> /dev/null && exit 2
    if ! vboxmanage list vms | grep "^\"${1}\" "; then
      echo "invalid: $1"
      exit 3
    fi
    echo "${1}" > "$HOME"/dotfiles/etc/systemd/currentvm
    cat "$HOME"/dotfiles/etc/systemd/currentvm
    exit 0
    ;;
  "");;
  *) cat <<END
--- invalid argument ---
$*
END
    exit 1
    ;;
esac
unset -f helpmsg

if systemctl --user is-active $service &> /dev/null; then
  confirm "STOP $(cat "$HOME"/dotfiles/etc/systemd/currentvm)"
  echo "please wait for stop VM process"
  command -v "fortune" &> /dev/null && fortune -a
  systemctl --user stop $service
  echo "inactivate"
else
  confirm "START $(cat "$HOME"/dotfiles/etc/systemd/currentvm)"
  systemctl --user start $service
  echo "activate"
  command -v "fortune" &> /dev/null && fortune -a
fi
