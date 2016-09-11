#!/bin/bash

if [[ -d "$DOTFILES_ROOT/vim/sonicdir" ]]; then
  git add $DOTFILES_ROOT/vim/sonicdir/*
  git status

  # confirm
  key=""
  while [[ -z $key ]] || [[ $key != "yes" ]]; do
    echo "git commit [yes:no]?"
    read key

    if [[ $key = "no" ]] || [[ $key = "n" ]]; then
      echo "ok... stop process"
      exit 1
    fi
  done

  git commit
else
  echo "do not fnid template directory sonicdir"
fi

