#!/bin/bash

if [ -z "$1" ]; then echo "\$1=zero"; else echo "$1"; fi

[ ! -z "$2" ] && echo "$2"

echo 'compare $1 $2'
[ "$1" == "$2" ] && echo "equal" || echo "not equal"
