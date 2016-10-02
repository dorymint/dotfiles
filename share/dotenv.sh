# envdot

if ! [[ -d $HOME/dotfiles ]]; then
  echo 'not found $HOME/dotfiles'
fi

# env
if [[ -d $HOME/dotfiles ]] && [[ "$DOTFILES_ROOT" = "" ]]; then
  export DOTFILES_ROOT=$HOME/dotfiles
fi


