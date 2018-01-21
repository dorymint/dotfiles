#!/bin/sh
set -eu

unset -f helpmsg
helpmsg() {
	cat >&1 <<END
getter-toggle.sh
options:
	-h --help
		show this help
	-s --status
		show status
	--service
		specify name of service unit
	--timer
		specify name of timer unit
END
}
while [ -n "${1:-}" ]; do
	case "${1:-}" in
		-h|-help|--help)
			helpmsg
			exit 0
			;;
		-s|-status|--status)
			systemctl --user status getter.timer
			systemctl --user list-timers
			exit 0
			;;
		-service|--service)
			shift
			service="${1}"
			;;
		-timer|--timer)
			shift
			timer="$1"
			;;
		"")
			;;
		*)
			echo "unknown option: ${*}"
			exit 1
			;;
	esac
	shift
done
service=${service:-"getter.service"}
timer=${timer:-"getter.timer"}

if systemctl --user is-active $timer &> /dev/null; then
	systemctl --user stop $timer
	echo "timer deactivated"
else
	echo "starting $service ..."
	systemctl --user start $timer
	sleep 1
	if ! systemctl --user start $service; then
		systemctl --user stop $timer
		exit 1
	fi
	echo "timer activated"
fi
