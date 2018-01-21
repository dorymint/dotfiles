#!/bin/sh
if [ -d "$(/usr/bin/ruby -e 'print Gem.user_dir')"/bin ]; then
	export PATH=$(/usr/bin/ruby -e 'print Gem.user_dir')"/bin:${PATH}"
fi
