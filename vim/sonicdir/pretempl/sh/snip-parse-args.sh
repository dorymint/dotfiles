while [ -n "${1:-}" ]; do
	case "${1}" in
		"{{_cursor_}}")
			;;
	esac
	shift
done
