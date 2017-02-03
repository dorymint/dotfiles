#!bin/bash
# scriptencoding utf-8

echo $0
dotfiles_root=$(cd $(dirname $0)/../; pwd -P )
echo "$dotfiles_root"

echo ""
echo "make symlink"
echo ""

echo "zsh"
ln -s $dotfiles_root/zsh/zshrc $HOME/.zshrc

echo "bash"
ln -s $dotfiles_root/bash/bashrc $HOME/.bashrc

echo "git"
ln -s $dotfiles_root/gitconfig $HOME/.gitconfig

echo "vim"
ln -s $dotfiles_root/vim/vimrc $HOME/.vimrc
ln -s $dotfiles_root/vim/gvimrc $HOME/.gvimrc

echo "tmux"
ln -s $dotfiles_root/tmux/tmux.conf $HOME/.tmux.conf

echo "i3-wm"
ln -s $dotfiles_root/i3/ $HOME/.config/

# EOF
