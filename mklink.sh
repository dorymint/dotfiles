#!bin/bash
# script encoding=utf-8

echo $0
export dotfiles_root=$(cd $(dirname $0); pwd)
echo $dotfiles_root

echo make symboliclink
echo ""

echo zsh
ln -s $dotfiles_root/bash/zshrc $HOME/.zhsrc

echo bash
ln -s $dotfiles_root/bash/bashrc $HOME/.bashrc

echo vim
ln -s $dotfiles_root/vim/vimrc $HOME/.vimrc
ln -s $dotfiles_root/vim/gvimrc $HOME/.gvimrc

# eof
