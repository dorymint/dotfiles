#!/bin/sh
set -eu

# TODO: rewrite

dportn=-1
targetn=-1
deleten=-1
proto="tcp"

# help
helpmsg() {
  cat >&1 <<END
Options:
  -h --help
    Show help
  -s --show
    Show nft ruleset with target number
  -p --port (number)
    Specify accpet destination port number
  -u --udp
    Specify target protocol is to the udp (default is ${proto})
  -t --target (number)
    Specify target number
  -d --delete (number)
    Specify number for delete the rule

Examples:
  Show ruleset with target number
    nft-accept.sh -s
  Append the acceptable destination ports after target number in ruleset
    nft-accept.sh -a \$port -t \$target
  Append acceptable port 8080 after target 8 in ruleset
    nft-accept.sh -a 8080 -t 8
  Delete rule
    nft-accept.sh -d \$target

END
}

# show
show() {
  sudo nft list ruleset -a
}

# delete
delete() {
  sudo nft delete rule inet filter input handle ${deleten}
}

# help with error message
help_with_errmsg() {
  helpmsg
  echo "Invalid parameter: dportn=${dportn} targetn=${targetn} deleten=${deleten}"
}

# append
main() {
  sudo nft add rule inet filter input position ${targetn} ${proto} dport ${dportn} accept
}

while true; do
  case "${1:-}" in
    help|-help|--help|-h)
      helpmsg
      exit 0
      ;;
    -s|--show)
      show
      exit 0
      ;;
    -p|--port)
      shift
      dportn=${1}
      ;;
    -u|--udp)
      proto="udp"
      ;;
    -t|--target)
      shift
      targetn=${1}
      ;;
    -d|--delete)
      shift
      deleten=${1}
      ;;
    "")
      if [ ${deleten} -gt 0 ]; then
        if [ ${dportn} -lt 0 ] && [ ${targetn} -lt 0 ];then
          delete
          exit 0
        else
          help_with_errmsg
          exit 1
        fi
      fi
      if [ ${dportn} -lt 0 ] || [ ${targetn} -lt 0 ]; then
        help_with_errmsg
        exit 1
      fi
      main
      exit 0
      ;;
    *)
      helpmsg
      echo "Unknown option: ${*}"
      exit 1
      ;;
  esac
  shift
done
