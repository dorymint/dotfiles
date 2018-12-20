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
    count=$(( $count + 1 ))
    case "$key" in
      n|no) return 1;;
      y|yes) return 0;;
    esac
    echo -n "$msg"
    read key
  done
  echo "unreachable" >&2; exit 99
  )
}
