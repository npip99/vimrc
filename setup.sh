#!/bin/bash

# Setup error handling
set -e
trap 'echo "Error on line $LINENO!"' ERR

# Prompt user about this script
echo
read -p "This script is only prepared to run on Ubuntu or Mac OSX. Do you want to continue? (y/n) " -r
echo
if [[ ! "$REPLY" =~ ^[Yy](es)?$ ]]; then
  echo "Feel free to edit this script file as desired to make it work on your OS/distro. If you rewrite it for your own operating system / distro and it works, do let me know so I can add your script to this repository. Thanks!"
  echo
  exit
fi

# Check for existant ~/.vim or ~/.vimrc
if [[ -d ~/.vim || -f ~/.vimrc ]]; then
  read -p "An existant ~/.vim or ~/.vimrc has been found. Overwrite all contents? (y/n) " -r
  echo
  if [[ "$REPLY" =~ ^[Yy](es)?$ ]]; then
    rm -rf ~/.vim
    rm -f ~/.vimrc
  else
    echo "Cannot continue unless ~/.vim and ~/.vimrc no longer exist"
    echo
    exit 1
  fi
fi

# Install dependencies
if [[ "$OSTYPE" =~ ^darwin ]]; then
  brew install ccls nodejs clang-format vim
else
  sudo apt-get update -y
  pkgs='ccls nodejs clang-format vim-gtk3'
  if ! dpkg -s $pkgs >/dev/null 2>&1; then
    sudo apt-get install $pkgs -y
  fi
fi

# Setup Vim Plugins
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cp vimrc ~/.vimrc
echo "\n" | vim +PluginInstall +qall

# Copy coc-settings.json
cp coc-settings.json ~/.vim

# Find bashrc path based on OS
if [[ "$OSTYPE" =~ ^darwin ]]; then
  BASH_RC="$HOME/.profile"
else
  BASH_RC="$HOME/.bashrc"
fi

# Setup bashrc
if ! cat "$BASH_RC" | grep "Set vim as the default editor" > /dev/null; then
  echo >> "$BASH_RC"
  echo '# Set vim as the default editor' >> "$BASH_RC"
  echo 'export VISUAL=vim' >> "$BASH_RC"
  echo 'export EDITOR="$VISUAL"' >> "$BASH_RC"
  echo >> "$BASH_RC"
fi

if [[ ! "$OSTYPE" =~ ^darwin ]]; then
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

  # Install vim into root user
  # On Mac, the root user is /home/$USER
  echo
  read -p "Do you want to install this vimrc into the root user as well? (y/n) " -r
  echo
  if [[ "$REPLY" =~ ^[Yy](es)?$ ]]; then
    sudo rm -rf /root/.vim
    sudo rm -f /root/.vimrc
    sudo cp -r "$HOME/.vim" /root/.vim
    sudo cp "$HOME/.vimrc" /root/.vimrc
  fi
fi

echo "Done!"
echo
