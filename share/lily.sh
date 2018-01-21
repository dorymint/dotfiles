#!/usr/bin/bash

# TODO: consider implementation

set -eu

## test
bindir=$(dirname $(readlink -f ${0}))/bin
echo ${bindir}
ls ${bindir}
exit 0

[ -d "${HOME}"/dotfiles/share/bin ]
bindir="${HOME}"/dotfiles/share/bin
subcmd=""
list=$(ls --indicator-style=slash ${bindir})
showlist() {
	for x in ${list}; do
		echo "${x}"
	done
}
# help
helpmsg() {
	cat >&1 <<END
lily.sh
	for sub command
options:
	-help
	-list
examples:
	lily.sh [sub name] [args]
	lily.sh --help
		show this help
	lily.sh --list
		list of sub command
END
}
case "${1}" in
	help|--help|-h) helpmsg; exit 0;;
	list|--list|-l) showlist; exit 0;;
	*)subcmd=$1; shift;;
	"")echo "\$1 is not specify"; exit 1;;
esac
unset -f helpmsg
unset -f showlist

${bindir}/${subcmd} ${*}
