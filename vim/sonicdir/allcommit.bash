#!/bin/bash
set -eu

# confirm $1="confirm messsage"
function confirm() {
  local key=""
  local count=0
  while [[ "$key" != "yes" ]] && [[ "$key" != "y" ]]; do
    if [[ "$key" = "no" ]] || [[ "$key" = "n" ]] || [[ $count -gt 2 ]]; then
      echo "stop allcommit"
      exit 1
    fi
    count=$(expr $count + 1)

    echo "$1"
    read -t 60 key
  done
  return 0
}

if [[ -d "$DOTFILES_ROOT/vim/sonicdir" ]]; then
  cd "$DOTFILES_ROOT/vim/sonicdir"
  echo "git diff ."
  sleep 1
  git diff .
  git status
  confirm 'git add . [yes:no]?'
  git add .
  git status

  echo "git diff --cached -- ."
  sleep 1
  git diff --cached -- .
  confirm 'git commit -- . [yes:no]?'
  git commit -m "update sonic" -- .

  echo "git diff origin/master"
  sleep 1
  git diff origin/master
  git status
  confirm 'git push origin master [yes:no]?'
  git push origin master
fi
# EOF
