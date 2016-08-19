#!bin/bash
# script encoding=utf-8

echo $0
export dotfiles_root=$(cd $(dirname $0); pwd)
echo $dotfiles_root

echo make symboliclink

# use grml
ln -s $dotfiles_root/zsh/zshrc.grml $HOME/.zshrc
ln -s $dotfiles_root/zsh/zshrc.grml.local $HOME/.zshrc.local

ln -s $dotfiles_root/bash/bashrc $HOME/.bashrc

ln -s $dotfiles_root/vim/vimrc $HOME/.vimrc
ln -s $dotfiles_root/vim/gvimrc $HOME/.gvimrc

# eof
