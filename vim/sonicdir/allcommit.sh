#!/bin/bash

# add modified line test

# confirm
function confirm() {
  local key=""
  local count=0
  while [[ "$key" != "yes" ]] && [[ "$key" != "y" ]]; do
    if [[ "$key" = "no" ]] || [[ "$key" = "n" ]] || [[ $count -gt 2 ]]; then
      echo "ok... stop process"
      exit 1
    fi
    count=$(expr $count + 1)

    echo "$1"
    read key
  done
  return 0
}

if [[ -d "$DOTFILES_ROOT/vim/sonicdir" ]]; then
  cd "$DOTFILES_ROOT/vim/sonicdir" &&
  git diff origin/master &&
  git status ||
  exit 1

  confirm 'git add . [yes:no]?' &&
  git add . &&
  git status ||
  exit 1

  confirm 'git commit [yes:no]?' &&
  git commit &&
  git diff origin/master ||
  exit 1

  git status &&
  confirm 'git push origin master [yes:no]?' &&
  git push origin master ||
  exit 1

else
  echo "not found template directory sonicdir"
fi

# EOF
