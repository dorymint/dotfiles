#!/bin/sh
set -eu

list="next.list"

# TODO: fix exe
exe="echo"

# help
helpmsg() {
	cat >&1 <<END
append.sh
	TODO: fix cmd name

options:
	-help
		show this help
	-exec
		action
	-dry-run
		check results for -exec
END
}

# append to ${list}
# ${1}=${string}
append() {
	if grep -w "${1}" -- "${list}" &> /dev/null; then
		echo "duplicated: ${1}"
		exit 2
	fi

	echo "${1}" >> "${list}"
	echo "appended: ${1}"
	echo "cat:"
	cat "${list}"
}

dryrun() {
	local l=$(cat "${list}")
	for x in ${l}; do
		echo "${exe} ${x}"
		local delay=$(shuf -i 20-180 -n 1)
		echo "delay: ${delay}"
	done
}

cmd() {
	local l=$(cat "${list}")
	for x in ${l}; do
		${exe} "${x}"
		local delay=$(shuf -i 20-180 -n 1)
		echo "delay: ${delay}"
		sleep ${delay}
	done
	# trunc
	: > "${list}"
}

while [ -n "${1:-}" ]; do
	case "${1}" in
		help|-help|--help|-h) helpmsg; exit 0;;
		exec|-exec) cmd; exit 0;;
		dry-run|-dry-run) dryrun; exit 0;;
		*) append "${1}"; exit 0;;
	esac
	shift
done
unset -f helpmsg
