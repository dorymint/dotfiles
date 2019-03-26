#!/bin/sh
set -eu

name="grep-utils.sh"
editor="${EDITOR:-"vim"}"

# TODO: consider
user="$(git config --global user.name)"
file="$(readlink -e "$HOME"/src/github.com/"$user"/hello-world/md/utils.md)"

# grep options
options="--line-number --ignore-case --after-context=5"
color="auto"

helpmsg() {
  cat >&1 <<END
Usage:
  $name [Options] -- PATTERN

Options:
  -h, --help        Display this message
  -e, --edit        Open file by \$EDITOR (default $editor)
  --color           Always output with color
  --dir             Display parent directory

  -d, --diff        Run git diff
  -c, --commit      Run git commit
  -p, --push-master Run git push origin master

Examples:
  $name --help

END
}

errmsg() {
  echo "${name}: $*" 1>&2
}

abort() {
  errmsg "$*"
  exit 2
}

ckargv() {
  if [ $# -eq 0 ];then
    return 0
  else
    abort "invalid arguments: $*"
  fi
}

edit() {
  $editor "$file"
}

# confirm $1=msg return bool
confirm() {
  (
  key=""
  counter=0
  while [ $counter -lt 3 ]; do
    counter=$(( counter + 1 ))
    printf "%s" "$1 [yes:no]?>"
    read -r key || return 1
    case "$key" in
      no|n) return 1;;
      yes|y) return 0;;
    esac
  done
  return 1
  )
}

# for git
gdiff() {
  cd "$(dirname "$file")"
  git diff "$(basename "$file")"
}
gcommit() {
  (
  base="$(basename "$file")"
  msg="up $base"
  cd "$(dirname "$file")"
  git status
  git diff -- "$base"
  if confirm "git add -- \"$base\" && git commit -m \"$msg\" -- \"$base\""; then
    git add -- "$base"
    git commit -m "$msg" -- "$base"
  else
    abort "stopped"
  fi
  )
}
gpush() {
  cd "$(dirname "$file")"
  git status
  git diff --stat origin master
  printf "git diff origin master <enter>"
  read -r
  git diff origin master
  if confirm "git push origin master"; then
    git push origin master
  else
    abort "stopped"
  fi
}

main() {
  grep $options --color="$color" --regexp="$*" -- "$file"
}

while true; do
  case "${1:-}" in
    # base
    --)
      shift
      break
      ;;
    -h|--help|h|help|-help)
      shift
      helpmsg
      ckargv "$@"
      exit 0
      ;;
    -e|--edit)
      shift
      ckargv "$@"
      edit
      exit 0
      ;;
    --color)
      color="always"
      ;;
    --dir)
      shift
      ckargv "$@"
      dirname "$file"
      exit 0
      ;;

    # git
    -d|--diff)
      shift
      ckargv "$@"
      gdiff
      exit 0
      ;;
    -c|--commit)
      shift
      ckargv "$@"
      gcommit
      exit 0
      ;;
    -p|--push-master)
      shift
      ckargv "$@"
      gpush
      exit 0
      ;;

    # defaults
    "")
      errmsg "expected pattern but non"
      exit 1
      ;;
    *)
      break
      ;;
  esac
  shift
done

main "$*"

