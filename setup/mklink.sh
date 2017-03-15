#!bin/sh
# scriptencoding utf-8

echo $0
dotfiles_root=$(cd "$(dirname "$(readlink -f "$0")")"/../; pwd -P)
echo "$dotfiles_root"

echo ""
echo "make symlink"
echo ""
 
[ -d "$HOME"/.vim ] || mkdir "$HOME"/.vim
[ -d "$HOME"/.config ] || mkdir "$HOME"/.config
[ -d "$HOME"/gowork ] || mkdir -p "$HOME"/gowork/{bin,pkg,src}
#[ -d "$HOME"/go ] || mkdir -p "$HOME"/go/{bin,pkg,src}

echo "zsh"
ln -sn "$dotfiles_root"/zsh/zshrc "$HOME"/.zshrc
echo ""

echo "bash"
ln -sn "$dotfiles_root"/bash/bashrc "$HOME"/.bashrc
echo ""

echo "git"
ln -sn "$dotfiles_root"/gitconfig "$HOME"/.gitconfig
echo ""

echo "vim"
ln -sn "$dotfiles_root"/vim/vimrc "$HOME"/.vimrc
ln -sn "$dotfiles_root"/vim/gvimrc "$HOME"/.gvimrc
echo ""

echo "neovim"
ln -sn "$HOME"/.vim/ "$HOME"/.config/nvim
ln -sn "$dotfiles_root"/vim/vimrc "$HOME"/.vim/init.vim
echo ""

echo "tmux"
ln -sn "$dotfiles_root"/tmux/tmux.conf "$HOME"/.tmux.conf
echo ""

echo "i3-wm"
ln -sn "$dotfiles_root"/i3/ "$HOME"/.i3
echo ""

echo "termite"
ln -sn "$dotfiles_root"/termite/ "$HOME"/.config/
# EOF
