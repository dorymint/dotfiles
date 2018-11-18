#!/bin/bash
set -eu

# set variable
options="-v"
pkglist="$HOME/dotfiles/setup/golang/gopkg.list"

split() {
	echo "------- $1 -------"
}

# confirm $1=msg return bool
confirm() {
	local key=""
	local counter=0
	while [ $counter -lt 3 ]; do
		counter=`expr $counter + 1`
		echo -n "$1 [yes:no]?>"
		read -t 60 key || return 1
		case "$key" in
			no|n) return 1;;
			yes|y) return 0;;
		esac
	done
	return 1
}

# help
helpmsg() {
	cat >&1 <<END
gopkg-install.bash
	go pkg install scripts

optons:
	help -help --help -h
		show help message
	update -update --update -u
		add flag -u for go get
	file -file --file -f
		specify path to gopkg.list(default: $pkglist)
END
}
while [ -n "${1:-}" ]; do
	case "$1" in
		help|-help|--help|-h)
			helpmsg; exit 0
			;;
		update|-update|--update|-u)
			options="-v -u"
			;;
		file|-file|--file|-f)
			shift
			pkglist="$1"
			;;
		"")
			# TODO: consider
			;;
	esac
	shift
done
unset -f helpmsg

# check
split "require"
type go
type gawk
if [ ! -r "${pkglist}" ] || [ ! -f "${pkglist}" ]; then
	echo "can't read ${pkglist}"
	exit 1
fi

# parse
awkout=$(gawk '/^[^#].*/ { print $0 }' "$pkglist")

# info && confirm
split "go env"
go version
go env
sleep 1
split "install list"
for x in ${awkout}; do
	echo "${x}"
done
split "confirm"
confirm "install packages? Run: go get ${options}"

# install && update
echo "Run: go get ${options} pkg"
for x in ${awkout}; do
	go get ${options} ${x}
done
echo "...finish"

# vim: set noexpandtab shiftwidth=2 tabstop=2 softtabstop=2
