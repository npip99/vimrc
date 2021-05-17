#!/bin/bash

# Setup error handling
set -e
trap 'echo "Error on line $LINENO!"' ERR

# Prompt user about this script
read -p "This script is only prepared to run on Ubuntu. Do you want to continue? (y/n) " -r
echo
if [[ ! "$REPLY" =~ ^[Yy](es)?$ ]]; then
  echo "Feel free to edit this script file as desired to make it work on your distro. If you rewrite it for your own operating system / distro and it works, do let me know so I can add your script to this repository. Thanks!"
  echo
  exit
fi

# Update apt-get
sudo apt update -y

# Install clss
sudo apt install ccls -y

# Install nodejs
sudo apt install nodejs -y

# Install clang-format
sudo apt install clang-format -y

# Install Vim
sudo apt install vim-gtk3 -y

# Setup Vim Plugins
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
if [[ -f ~/.vimrc ]]; then
  mv ~/.vimrc ~/.vimrc.bak
fi
cp vimrc ~/.vimrc
echo "\n" | vim +PluginInstall +qall

# Copy coc-settings.json
cp coc-settings.json ~/.vim

# Setup bashrc
if ! cat ~/.bashrc | grep "Set vim as the default editor" > /dev/null; then
  echo >> ~/.bashrc
  echo '# Set vim as the default editor' >> ~/.bashrc
  echo 'export VISUAL=vim' >> ~/.bashrc
  echo 'export EDITOR="$VISUAL"' >> ~/.bashrc
  echo >> ~/.bashrc
fi

# Prompt for caps lock to ctrl remap
echo
read -p "Do you want to remap CAPS LOCK to CTRL? (y/n) " -r
echo
if [[ "$REPLY" =~ ^[Yy](es)?$ ]]; then
  echo Executing \"setxkbmap -option ctrl:nocaps ...\"
  setxkbmap -option ctrl:nocaps
  echo Adding \"setxkbmap -option ctrl:nocaps\" to ~/.profile ...
  if ! cat ~/.profile | grep "Remap CAPS LOCK to CTRL" > /dev/null; then
    echo >> ~/.profile
    echo '# Remap CAPS LOCK to CTRL' >> ~/.profile
    echo 'setxkbmap -option ctrl:nocaps' >> ~/.profile
    echo >> ~/.profile
  fi
else
  echo In the future, you can do this with \"setxkbmap -option ctrl:nocaps\"
  echo This command can be added to your \"~/.profile\" to execute on login
fi
echo
echo Deactivating can be done by typing \"setxkbmap -option\"
echo Deactivating can be done permanently by editing \"~/.profile\"
echo

echo
read -p "Do you want to install this vimrc into the root user as well? (y/n) " -r
echo
if [[ "$REPLY" =~ ^[Yy](es)?$ ]]; then
  sudo rm -rf /root/.vim
  sudo rm -f /root/.vimrc
  sudo cp -r "$HOME/.vim" /root/.vim
  sudo cp "$HOME/.vimrc" /root/.vimrc
fi
echo "Done!"
echo
