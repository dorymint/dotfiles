#!/bin/sh
set -eu

[ -x "$(which gotcha)" ]
[ -x "$(which peco)" ]

word="TODO: "
file=""
root="./"

# help
helpmsg() {
	cat >&1 <<'END'
todovim.sh
	vim "$(gotcha | peco)"

options:
	root --root -r
	word --wrod -w

	$1 is same flag the -root
END
}
while [ -n "${1:-}" ]; do
	case "$1" in
		help|--help|-h)helpmsg; exit 0;;
		word|--word|-w)shift; word="$1";;
		root|-root|-r)shift; root="$1";;
		*)root="$1";;
	esac
	shift
done
unset -f helpmsg

file="$(gotcha -root="$root" -word="$word" -total | peco)"
[ -z "$file" ] && exit 1
vim "$file"
