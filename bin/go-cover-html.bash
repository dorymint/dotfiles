#!/bin/bash
set -eu

helpmsg() {
	cat >&1 <<END
go-cover-html.bash
	get coverage for golang
		go test current directory
		test && race && cover && to browser
		create or override "./cover.prof"
options:
	-help
		show this help
END
}

case "${1:-}" in
	-h|-help|--help) helpmsg; exit 0;;
esac

prof=cover.prof
if [ -f "$prof" ]; then
	printf "%s\noverride? [yes:no]>" "$prof"
	read -r key
	case "$key" in
		yes|y);;
		*)
			printf "stopped\n"
			exit 2
			;;
	esac
fi

go test -race -cover -coverprofile "$prof"
go tool cover -html "$prof"

# vim:noexpandtab:shiftwidth=2:tabstop=2:softtabstop=2:
