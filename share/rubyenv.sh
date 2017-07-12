#!/bin/sh
if [ -d "$HOME"/.gem/"$(/usr/bin/ruby -e 'print Gem.user_dir')"/bin ]; then
  export PATH="$HOME/.gem/"$(/usr/bin/ruby -e 'print Gem.user_dir')"/bin:$PATH"
fi
# EOF
