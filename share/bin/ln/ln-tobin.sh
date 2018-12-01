#!/bin/sh
set -eu

dir="$HOME"/bin
unset force

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

errmsg() {
  echo "[err] ln-tobin.sh: $*" 1>&2
}

abort() {
  errmsg "$*"
  exit 2
}

main() {
  if  [ ! -d "$dir" ]; then
    abort "not directory: $dir"
  fi
  local fullpaths
  fullpaths="$(readlink --verbose -e -- "$@")"
  for x in "$fullpaths"; do
    if [ ! -x "$x" ]; then
      echo "unexecutable: $x"
      continue
    fi
    ln ${force:-} --verbose --symbolic --target-directory="$dir" -- "$x"
  done
}

while true; do
  case "${1:-}" in
    -h|--help|h|help|-help)
      helpmsg
      exit 0
      ;;
    -f|--force)
      force="--force"
      ;;
    "")
      helpmsg
      errmsg "missing file operand"
      exit 1
      ;;
    --)
      shift
      main "$@"
      exit 0
      ;;
    *)
      main "$@"
      exit 0
      ;;
  esac
  shift
done
