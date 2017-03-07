# help
unset -f helpmsg
helpmsg() {
  cat >&1 <<END
  {{_cursor_}}
END
}
case "${1:-}" in
  ""|"-h"|"--help") helpmsg; exit 0;;
esac
unset -f helpmsg
