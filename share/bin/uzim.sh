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
uzim.sh
  ${name}.sh "\${target_archive}"
options:
  -help
    this help
  -show
    show current images
  -only-extract
    do only extract
END
}

viwer() {
  command -v feh
  cd "${tmpdir}"
  feh --scale-down --borderless --recursive -- "${imgdir}"
}

remove() {
  echo "remove ${tmpdir}/*"
  rm --one-file-system --recursive --force -- "${tmpdir}"/*
  echo "removed"
}

extract() {
  remove
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
    only|extract|-only-extract|--only-extract)
      shift
      extract "${1}"
      exit 0
      ;;
    *)
      extract "${1}"
      viwer
      exit 0
      ;;
  esac
  shift
done
unset -f helpmsg

echo "require path to archives" >&2
exit 1
