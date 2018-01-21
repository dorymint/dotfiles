#!/bin/sh
set -eu
if [ -d "${HOME}"/Pictures/links ]; then
	walldir="${HOME}"/Pictures/links
	feh --bg-max "${walldir}"/"$(ls "${walldir}" | shuf -n 1)"
fi
