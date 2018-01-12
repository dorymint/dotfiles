#!/bin/bash
set -eu
# confirm $1="confirm messsage"
confirm() {
  local key=""
  local count=0
  while [[ "$key" != "yes" ]] && [[ "$key" != "y" ]]; do
    if [[ "$key" = "no" ]] || [[ "$key" = "n" ]] || [[ $count -gt 2 ]]; then
      return 1
    fi
    count=$(expr $count + 1)

    echo -n "$1"
    read -t 60 key
  done
  return 0
}
commit() {
  if [[ -d "$1" ]]; then
    cd "$1"; pwd
    echo "git diff ."
    git diff .
    git status .
    confirm 'git add . [yes:no]?>' || return 0
    git add .
    git status

    echo "git diff --cached -- ."
    git diff --cached -- .
    confirm 'git commit -- . [yes:no]?>' || return 0
    git commit -m "update sonic" -- .

    echo "git diff origin/master"
    git diff origin/master
    git status
    confirm 'git push origin master [yes:no]?>' || return 0
    git push origin master
  fi
}
split() {
  echo "------- $1 -------"
  commit "$1"
  echo ""
}
split "$HOME/dotfiles/vim/sonicdir/pretempl"
split "$HOME/dotfiles/vim/sonicdir/templ"
# EOF
