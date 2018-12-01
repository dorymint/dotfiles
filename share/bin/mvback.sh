#!/bin/sh
set -eu

# Consider
dir="${HOME}/backup"

prefix="_$(date +%Y-%m-%d-h%Hm%Ms%S)-back_"
dryrun="false"

helpmsg() {
  cat >&1 <<END
Description:
  file move to backup directory (default: $dir)

Usage:
  mvback.sh [Options] TARGETFILES

Options:
  -h, --help        Display this message
  -d, --dry-run     Do not acutually
  -i, --interactive Prompt before overwriting exiting file

Examples:
  mvback.sh --help

END
}

errmsg() {
  echo "[err] mvback.sh: $*" 1>&2
}

abort() {
  errmsg "$*"
  exit 3
}

main() {
  if [ ! -d "${dir}" ]; then
    abort "not found: ${dir}"
  fi
  if [ "${dryrun}" = "true" ]; then
    for x in "$@"; do
      echo "\"${x}\" to \"${dir}/${prefix}${x}\""
    done
  else
    for x in "$@"; do
      mv --no-target-directory --no-clobber -- "${x}" "${dir}/${prefix}${x}"
    done
  fi
}

while true; do
  case "${1:-}" in
    -h|--help|h|help|-help)
      helpmsg
      exit 0
      ;;
    -d|--dry-run|-dry-run)
      dryrun="true"
      ;;
    "")
      helpmsg
      errmsg "missing file operand"
      exit 1
      ;;
    *)
      main "$@"
      exit 0
      ;;
  esac
  shift
done
