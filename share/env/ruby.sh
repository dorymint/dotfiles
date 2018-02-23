# ruby
[ -d "$(/usr/bin/ruby -e 'print Gem.user_dir')"/bin ] && export PATH="$PATH":"$(/usr/bin/ruby -e 'print Gem.user_dir')"/bin
