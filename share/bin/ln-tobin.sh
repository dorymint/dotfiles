#!/bin/sh
set -eu

dir="$HOME"/bin
force=false

helpmsg() {
  cat >&1 <<END
Description:
  Create symbolic links to local bin directory (default $dir)

Usage:
  ln-tobin.sh [Options] EXECUTABLE

Options:
  -h, --help  Display this message
  -f, --force Remove existing destination files

Examples:
  ln-tobin.sh --help

END
}

abort() {
  echo "$*" >&2
  exit 2
}

main() {
  (
  [ -d "$dir" ] || abort "not directory: $dir"
  fullpaths="$(readlink --verbose -e -- "$@")"
  for x in "$fullpaths"; do
    if [ ! -x "$x" ]; then
      echo "unexecutable: $x"
      continue
    fi

    options="--verbose --symbolic --target-directory="$dir""
    if [ "$force" = "true" ]; then
      options="--force $options"
    fi
    ln $options -- "$x"
  done
  )
}

while true; do
  case "${1:-}" in
    --)
      shift
      main "$@"
      exit 0
      ;;
    -h|--help|h|help|-help)
      helpmsg
      exit 0
      ;;
    -f|--force)
      force="true"
      ;;
    "")
      helpmsg
      abort "missing file operand"
      ;;
    *)
      main "$@"
      exit 0
      ;;
  esac
  shift
done

