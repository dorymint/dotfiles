#!bin/sh
# script encoding=utf-8

echo $0
export dotfiles_root=$(cd $(dirname $0); pwd)
echo $dotfiles_root

echo make symboliclink

# use grml
ln -s $dotfiles_root/zsh/zshrc.grml ~/.zshrc
ln -s $dotfiles_root/zsh/zshrc.grml.local ~/.zshrc.local

ln -s $dotfiles_root/vim/vimrc ~/.vimrc
ln -s $dotfiles_root/vim/gvimrc ~/.gvimrc

# eof
