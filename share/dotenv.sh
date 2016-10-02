# dotenv

if [[ -d $HOME/dotfiles ]]; then
  if [[ "$DOTFILES_ROOT" = "" ]]; then
    export DOTFILES_ROOT=$HOME/dotfiles
  fi
else
  echo 'not found $HOME/dotfiles'
fi
# EOF
