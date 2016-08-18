#!bin/sh
# script encoding=utf-8

echo $0
export dotfiles_root=$(cd $(dirname $0); pwd)
echo $dotfiles_root

echo make symboliclink

ln -s $dotfiles_root/zsh/zshrc ~/.zshrc

ln -s $dotfiles_root/vim/vimrc ~/.vimrc
ln -s $dotfiles_root/vim/gvimrc ~/.gvimrc

# eof
