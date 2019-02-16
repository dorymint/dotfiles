#!/bin/sh
set -eu

options="-v"
pkglist="$HOME/dotfiles/setup/go/gopkg.list"
upgrade=false

helpmsg() {
	cat >&1 <<END
Usage:
  go-pkg-install.sh [Options]

Optons:
  -h, --help    Display this message
  -u, --upgrade Append flag "-u" to "go get"
  -f, --file    Specify path to gopkg.list (default: $pkglist)

END
}

# confirm $1=msg return bool
confirm() {
	(
	# which one?
	msg="${1:-} [yes:no]?> "
	#msg="${1:-}"
	key=""
	count=1
	while true; do
		[ $count -gt 3 ] && return 1
		count=$(( count + 1 ))
		case "$key" in
			n|no) return 1;;
			y|yes) return 0;;
		esac
		printf "%s\n" "$msg"
		read -r key
	done
	echo "unreachable" >&2; exit 99
	)
}

abort() {
	echo "$*" >&2
	exit 2
}

ckcom() {
	command -v "$1" 1> /dev/null || abort "command not found"
}

main() {
	# depends
	ckcom "gawk"
	ckcom "go"

	# parse
	awkout="$(gawk '/^[^#].*/ { print $0 }' "$pkglist")"

	go version
	go env
	echo "-- install list ---"
	for x in $awkout; do
		echo "$x"
	done
	echo "-------------------"

	[ "$upgrade" = "true" ] && options="$options -u"

	confirm "install packages? go get $options \$pkgs"
	for x in $awkout; do
		go get $options -- "${x}"
	done
}

while [ $# -ne 0 ]; do
	case "$1" in
		-h|--help|help|-help)
			helpmsg
			exit 0
			;;
		-u|--upgrade)
			upgrade=true
			;;
		-f|--file)
			shift
			pkglist="$1"
			;;
		*)
			abort "invalid arguments: $*"
			;;
	esac
	shift
done

main

# vim: noexpandtab shiftwidth=2 tabstop=2 softtabstop=2
