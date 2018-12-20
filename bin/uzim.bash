#!/bin/bash
set -eu

# depend
echo "depend commands"
command -v feh
command -v pdfimages
command -v atool
echo ""

# TODO: consider
name="uzim.bash"
feh_workdir="$HOME"/tmp/"$name"
imgdir="$HOME"/tmp/"$name"/ext

# feh
feh_options="--scale-down --borderless --recursive"
# for feh --slideshow-delay "$delay"
delay=0
# for feh --on-last-slide "$on_last_slide"
on_last_slide="resume"
# for feh --fullscreen
fullscreen=false

# help
helpmsg() {
  cat >&1 <<END
Usage:
  $name [Options] ARCHIVE

Options:
  -h, --help                     Display this message
  -s, --show                     Show current images
  -e, --extract                  Running only extract
  # TODO: impl
  -r, --recuresive               Recuresive to extract and view
  -d, --delay UINT               Specify delay for slideshow
  -o, --on-last-slide [Keywords] Specify action for to the next on the last image
  -f, --fullscreen               Display image with fullscreen

Keywords:
  -o, --on-last-slide (default: $on_last_slide)
    h|hold   Stop slideshow on the last image
    q|quit   Exit slideshow
    r|resume To first image

Examples:
  # recursive extract and view on current directory
  \$ for x in *; do $name -f -d 4 -o quit -- "\$x"; sleep 1; done

END
}

errmsg() {
  echo "$name: $*" 1>&2
}

abort() {
  errmsg "$*"
  exit 2
}

view() {
  (
  # treat for follow case of saving new file at slideshow
  cd "$feh_workdir"

  feh_options="$feh_options --on-last-slide $on_last_slide"
  [ "$fullscreen" = "true" ] && feh_options="$feh_options --fullscreen"
  [ $delay -gt 0 ] && feh_options="$feh_options --slideshow-delay $delay"

  echo "feh options: $feh_options -- \"$imgdir\""
  feh $feh_options -- "$imgdir"
  )
}

extract() {
  (
  archive="$(readlink -e "$1")"

  # remove cache
  echo "remove cache in $imgdir"
  rm --one-file-system --recursive --force -- "$imgdir"
  mkdir "$imgdir"

  echo "extracting $archive to $imgdir"
  case "$archive" in
    *.pdf)
      pdfimages -- "$archive" "$imgdir"/pdfimages
      ;;
    *)
      atool --extract-to="$imgdir" -- "$archive"
      ;;
  esac
  )
}

recursive() {
  echo "not implemented"
}

main() {
  extract "$1"
  view
}

while true; do
  case "$1" in
    --)
      shift
      [ $# -eq 1 ] || abort "invalid arguments: $*"
      break
      ;;
    -h|--help|-help)
      helpmsg
      [ $# -eq 1 ] || abort "invalid arguments: $*"
      exit 0
      ;;
    -s|--show)
      [ $# -eq 1 ] || abort "invalid arguments: $*"
      view
      exit 0
      ;;
    -e|--extract)
      shift
      [ $# -eq 1 ] || abort "invalid arguments: $*"
      extract "$1"
      exit 0
      ;;
    -r|--recuresive)
      shift
      [ $# -eq 1 ] || abort "invalid arguments: $*"
      recursive "$1"
      exit 0
      ;;
    -d|--delay)
      shift
      case "$1" in
        ''|*[!0-9]*) abort "invalid arguments: $*";;
        *);;
      esac
      delay=$1
      ;;
    -o|--on-last-slide)
      shift
      case "$1" in
        h|hold) on_last_slide=hold;;
        q|quit) on_last_slide=quit;;
        r|resume) on_last_slide=resume;;
        *) abort "invalid arguments: $*";;
      esac
      ;;
    -f|--fullscreen)
      fullscreen=true
      ;;
    *)
      [ $# -eq 1 ] || abort "invalid arguments: $*"
      break
      ;;
  esac
  shift
done
main "$1"

