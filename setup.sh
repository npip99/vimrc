#!/bin/sh

rvm get head
sudo rvm install 2.3.1
cp vimrc ~/.vimrc
yes "" | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/linuxbrew/go/install)"
sudo apt-get install build-essential
export LD_LIBRARY_PATH="/usr/local/rvm/rubies/ruby-2.3.1/lib:$LD_LIBRARY_PATH"
export PATH="$HOME/.linuxbrew/bin:$PATH"
export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
sudo chmod +t /tmp
brew install luajit
brew install vim --with-luajit
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
