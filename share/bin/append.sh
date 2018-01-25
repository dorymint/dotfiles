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
	append arguments to ${list}

options:
	-help
		show this help
	-exec
		action
	-dry-run
		check results for -exec
	-xclip
		append from xclip
END
}

isvalid() {
	if echo "${1:-}" | grep -e '^https\?://*' &> /dev/null; then
		return 0
	fi
	return 1
}

# append to ${list}
# ${1}=${string}
append() {
	if ! isvalid "${1}"; then
		echo "invalid arguments: ${1}"
		return 2
	fi
	if grep -w "${1}" -- "${list}" &> /dev/null; then
		echo "duplicated: ${1} in ${list}"
		return 2
	fi

	echo "${1}" >> "${list}"
	echo "appended: ${1}"
	echo "--- cat ${list} ---"
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

action() {
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
		help|-help|--help|-h)
			helpmsg
			exit 0
			;;
		exec|-exec)
			action
			exit 0
			;;
		dry-run|-dry-run)
			dryrun
			exit 0
			;;
		xclip|-xclip)
			append "$(xclip -o)"
			exit 0
			;;
		*)
			append "${1}"
			exit 0
			;;
	esac
	shift
done
helpmsg
exit 1
