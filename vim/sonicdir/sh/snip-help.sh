# help
unset -f helpmsg
helpmsg() {
  cat >&1 <<END
  {{_cursor_}}
END
}
while [ -n "${1:-}" ]; do
  case "$1" in
   "help"|"--help"|"-h") helpmsg; exit 0;;
  esac
  shift
done
unset -f helpmsg
