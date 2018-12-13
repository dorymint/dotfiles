case "$1" in
  ''|*[!0-9]*) printf "not number" ;;
  *) printf "number" ;;
esac
