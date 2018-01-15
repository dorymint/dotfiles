#!/bin/sh

# unzip and view images

set -eu

# TODO: consider
name="uzim"
tmpdir="${HOME}"/tmp/"${name}"
imgdir="${tmpdir}"/ext

# help
helpmsg() {
  cat >&1 <<END
usage:
  ${name}.sh "\${target_archive}"
option:
  -help	this help
  -show	show current images
END
}

viwer() {
  command -v feh
  cd "${tmpdir}"
  feh --scale-down --borderless --recursive -- "${imgdir}"
}

main() {
  rm -rf "${tmpdir}"/*
  [ -d "${imgdir}" ] || mkdir -p "${imgdir}"
  local target="$(readlink -f "${1}")"
  case "${target}" in
    *.pdf)
      command -v pdfimages
      pushd "${imgdir}"
      pdfimages -- "${target}" "pdfimages"
      popd
      ;;
    *)
      command -v atool
      atool --extract-to="${imgdir}" -- "${target}"
      ;;
  esac
  viwer
}

while [ -n "${1:-}" ]; do
  case "${1}" in
    help|-help|--help|-h)
      helpmsg
      exit 0
      ;;
    show|-show|--show|-s)
      viwer
      exit 0
      ;;
    *)
      main "${1}"
      exit 0
      ;;
  esac
  shift
done
unset -f helpmsg

echo "require path to archives" >&2
exit 1
