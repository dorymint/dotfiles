#!/bin/bash

echo $DOTFILES_ROOT
echo '$DOTFILES_ROOT'
echo "$DOTFILES_ROOT"

if [[ -d "$DOTFILES_ROOT/vim/sonicdir" ]]; then
  git add $DOTFILES_ROOT/vim/sonicdir/*
  git commit
else
  echo "do not fnid template directory sonicdir"
fi

