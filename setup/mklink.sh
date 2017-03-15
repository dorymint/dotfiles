#!bin/bash
# scriptencoding utf-8

echo $0
dotfiles_root=$(cd $(dirname $0)/../; pwd -P )
echo "$dotfiles_root"

echo ""
echo "make symlink"
echo ""
 
[ -d $HOME/.vim ] || mkdir $HOME/.vim
[ -d $HOME/.config ] || mkdir $HOME/.config
[ -d $HOME/gowork ] || mkdir -p $HOME/gowork/{bin,pkg,src}

echo "zsh"
ln -s $dotfiles_root/zsh/zshrc $HOME/.zshrc
echo ""

echo "bash"
ln -s $dotfiles_root/bash/bashrc $HOME/.bashrc
echo ""

echo "git"
ln -s $dotfiles_root/gitconfig $HOME/.gitconfig
echo ""

echo "vim"
ln -s $dotfiles_root/vim/vimrc $HOME/.vimrc
ln -s $dotfiles_root/vim/gvimrc $HOME/.gvimrc
echo ""

echo "neovim"
ln -s $HOME/.vim/ $HOME/.config/nvim
ln -s $dotfiles_root/vim/vimrc $HOME/.vim/init.vim
echo ""

echo "tmux"
ln -s $dotfiles_root/tmux/tmux.conf $HOME/.tmux.conf
echo ""

echo "i3-wm"
ln -s $dotfiles_root/i3/ $HOME/.i3
echo ""

echo "termite"
ln -s $dotfiles_root/termite/ $HOME/.config/
# EOF
