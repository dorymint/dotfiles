# ruby
if [ -x "$(builtin command -v ruby)" ]; then
	if [ -d "$(/usr/bin/ruby -e 'print Gem.user_dir')"/bin ]; then
		export PATH="$PATH":"$(/usr/bin/ruby -e 'print Gem.user_dir')"/bin
	fi
fi
