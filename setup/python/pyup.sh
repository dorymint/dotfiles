#!/bin/sh
set -eu

# req: python >=3.6

#name="$(basename $0)"
name="pyup.sh"

root="$HOME"/python/venv
force=false

helpmsg() {
  cat >&1 <<END
Description:
  create "venv" in "$root"
  see "python -m venv --help"

Usage:
  $name [Options]

Options:
  -h, --help  Display this message
  -f, --force Accept overwrite "$root"

Examples:
  $name --help
END
}

errmsg() {
  echo "$name: $*" 1>&2
}

abort() {
  errmsg "$*"
  exit 2
}

main() {
  if [ -n "${VIRTUAL_ENV:-}" ]; then
    abort "venv is activated"
  fi
  if [ -e "$root" ] && [ "$force" != "true" ]; then
      abort "already exists: $root"
  fi

  if [ -d "$root" ]; then
    python -m venv --upgrade -- "$root"
    echo "upgraded venv in \"$root\""
  else
    python -m venv -- "$root"
    echo "created venv in \"$root\""
  fi
}

while true; do
  case "${1:-}" in
    --)
      shift
      break
      ;;
    -h|--help|h|help|-help)
      helpmsg
      shift
      [ $# -eq 0 ] || abort "invalid arguments: $*"
      exit 0
      ;;
    -f|--force)
      force=true
      ;;
    *)
      break
      ;;
  esac
  shift
done

main "$@"

