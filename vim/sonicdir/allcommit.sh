#!/bin/bash

if [[ -d "$DOTFILES_ROOT/vim/sonicdir" ]]; then
  cd "$DOTFILES_ROOT/vim/sonicdir" &&
  git add ./* &&
  git status ||
  exit

  # confirm
  key=""
  count=0
  while [[ -z "$key" ]] || [[ "$key" != "yes" ]]; do
    if [[ "$key" = "no" ]] || [[ "$key" = "n" ]] || [[ $count -gt 2 ]]; then
      echo "ok... stop process"
      exit 1
    fi
    count=$(expr $count + 1)

    echo "git commit [yes:no]?"
    read key
  done

  git commit
else
  echo "do not fnid template directory sonicdir"
fi

