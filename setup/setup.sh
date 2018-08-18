#!/bin/sh
set -euB

# TODO: consider setup scripts

split() {
	echo "------- setup ${1} -------"
}

# help
helpmsg() {
	cat >&1 <<END
setup.sh
	make directory and symlinks
options:
	-help -h
		show this help
	-force -f
		allow override exists files
	-withx
		setup with xorg
END
}
while [ -n "${1:-}" ]; do
	case "$1" in
		help|-help|--help|-h) helpmsg; exit 0;;
		-force|--force|-f) lnopt="-f";;
		-withx|--withx|-x) withx="yes";;
	esac
	shift
done
unset -f helpmsg

dotroot=$(dirname $(dirname "$(readlink -f "$0")"))
lnopt="-sn ""${lnopt:-}"

[ -d "$HOME"/.vim ] || mkdir "$HOME"/.vim
[ -d "$HOME"/bin ] || mkdir "$HOME"/bin
[ -d "$HOME"/.config ] || mkdir "$HOME"/.config

# TODO: coonsider mkdir for golang
[ -d "$HOME"/go ] || mkdir -p "$HOME"/go/{bin,pkg,src}

# fallthrough
set +e
	split "zsh"
	ln $lnopt "$dotroot"/zsh/zshrc "$HOME"/.zshrc
	ln $lnopt "$dotroot"/zsh/zprofile "$HOME"/.zprofile

	split "bash"
	ln $lnopt "$dotroot"/bash/bashrc "$HOME"/.bashrc
	ln $lnopt "$dotroot"/bash/bash_profile "$HOME"/.bash_profile

	split "git"
	ln $lnopt "$dotroot"/gitconfig "$HOME"/.gitconfig

	split "vim"
	ln $lnopt "$dotroot"/vim/vimrc "$HOME"/.vimrc
	ln $lnopt "$dotroot"/vim/gvimrc "$HOME"/.gvimrc

	split "tmux"
	ln $lnopt "$dotroot"/tmux/tmux.conf "$HOME"/.tmux.conf
set -e

# for xorg
if [ "${withx:-}" = "yes" ]; then
	split "xorg"
	[ -d "$HOME"/.config/systemd/user ] || mkdir -p "$HOME"/.config/systemd/user

	# fallthrough
	set +e
	ln $lnopt "$dotroot"/x/xinitrc "$HOME"/.xinitrc
	# TODO: consider to remove
	#ln $lnopt "$dotroot"/x/xserverrc "$HOME"/.xserverrc
	ln $lnopt "$dotroot"/x/Xresources "$HOME"/.Xresources
	ln $lnopt "$dotroot"/x/fontconfig/ "$HOME"/.config/fontconfig

	# window manager
	ln $lnopt "$dotroot"/x/i3/ "$HOME"/.i3
	ln $lnopt "$dotroot"/x/sway/ "$HOME"/.sway

	# config
	ln $lnopt "$dotroot"/x/termite/ "$HOME"/.config/termite
	ln $lnopt "$dotroot"/x/conky/ "$HOME"/.config/conky
	ln $lnopt "$dotroot"/x/dunst/ "$HOME"/.config/dunst
	# TODO: consider to use default config and run compton -b -c -m 0.75
	#ln ${lnopt} "${dotroot}"/x/compton/compton.conf "${HOME}"/.config/compton.conf
	set -e
fi
