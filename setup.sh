#!/bin/bash

read -p "This script is only prepared to run on Ubuntu. Do you want to continue? (y/n) " -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  echo "Feel free to edit this script file as desired. If you rewrite it for your own operating system and it works, do let me know so I can add your script to this repository. Thanks!"
  exit
fi

# Update apt-get
sudo apt-get update

# Install Java 7
sudo apt-get install openjdk-7-jdk

# Update GCC
sudo apt-get install g++-6
sudo rm /usr/bin/g++
sudo ln -s /usr/bin/g++-6 /usr/bin/g++
sudo rm /usr/bin/gcc
sudo ln -s /usr/bin/gcc-6 /usr/bin/gcc

# Install clang-format
sudo apt-get install clang-format-3.6
sudo rm -rf /usr/bin/clang-format
sudo ln -s /usr/bin/clang-format-3.6 /usr/bin/clang-format

# Setup VIM
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
sudo apt install vim-gnome

if ! cat ~/.bashrc | grep "export VISUAL=vim" > /dev/null; then
  echo >> ~/.bashrc
  echo '# Set vim as the default editor' >> ~/.bashrc
  echo 'export VISUAL=vim' >> ~/.bashrc
  echo 'export EDITOR="$VISUAL"' >> ~/.bashrc
  echo >> ~/.bashrc
fi

read -p "Do you want to remap CAPS LOCK to CTRL? (y/n) " -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo Executing \"setxkbmap -option ctrl:nocaps\"
  setxkbmap -option ctrl:nocaps
else
  echo In the future, you can do this with \"setxkbmap -option ctrl:nocaps\"
fi
echo Deactiving can be done with \"setxkbmap -option\"
