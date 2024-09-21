#!/bin/bash

# Setup error handling
set -e
trap 'echo "Error at $BASH_SOURCE on line $LINENO!"' ERR

ALWAYS_YES=
if [[ "$1" == "-y" ]]; then
  ALWAYS_YES="y"
fi

maybe_read () {
  if [[ ! -z "$ALWAYS_YES" ]]; then
    echo "$1 y"
    export REPLY="y"
  else
    read -p "$1" -r
    echo
  fi
}

# Prompt user about this script
echo
maybe_read "This script is only prepared to run on Ubuntu or Mac OSX. Do you want to continue? (y/n) "
if [[ ! "$REPLY" =~ ^[Yy](es)?$ ]]; then
  echo "Feel free to edit this script file as desired to make it work on your OS/distro. If you rewrite it for your own operating system / distro and it works, do let me know so I can add your script to this repository. Thanks!"
  echo
  exit
fi

# Check for existant ~/.vim or ~/.vimrc
if [[ -d ~/.vim || -f ~/.vimrc ]]; then
  maybe_read "An existant ~/.vim or ~/.vimrc has been found. Overwrite all contents? (y/n) "
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
  brew install ccls node clang-format vim
else
  # Install any Apt Pre-requisites
  sudo apt-get update -y
  pkgs='curl ccls clang-format vim-gtk3'
  if ! dpkg -s $pkgs >/dev/null 2>&1; then
    sudo apt-get install $pkgs -y
  fi
  # Install NVM
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
  source ~/.nvm/nvm.sh
  # Install NodeJS and NPM
  nvm install 18.17.0
  nvm use 18.17.0
fi

# Setup Vim Plugins
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cp vimrc ~/.vimrc
# Install fzf via plugin instead of package manager, because apt's version is too old
echo "\n" | vim +PluginInstall +':call fzf#install()' +qall

# Copy coc-settings.json
cp coc-settings.json ~/.vim

# Checkout release version of coc
cd ~/.vim/bundle/coc.nvim
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git fetch --depth=1 origin release
git checkout release

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
  maybe_read "Do you want to remap CAPS LOCK to CTRL? (y/n) "
  if [[ "$REPLY" =~ ^[Yy](es)?$ ]]; then
    if ! which setxkbmap; then
      echo "Note: Could not find command \"setxkbmap\", will not remap CAPS LOCK to CTRL."
    else
      echo Executing \"setxkbmap -option ctrl:nocaps ...\"
      setxkbmap -option ctrl:nocaps
      echo Adding \"setxkbmap -option ctrl:nocaps\" to ~/.profile ...
      if ! cat ~/.profile | grep "Remap CAPS LOCK to CTRL" > /dev/null; then
        echo >> ~/.profile
        echo '# Remap CAPS LOCK to CTRL' >> ~/.profile
        echo 'setxkbmap -option ctrl:nocaps' >> ~/.profile
        echo >> ~/.profile
      fi
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
  ROOT_HOME=/root
  if [[ "$HOME" -ef "$ROOT_HOME" ]]; then
    echo "Installed this vimrc into root!"
  else
    maybe_read "Do you want to install this vimrc into the root user as well? (y/n) "
    if [[ "$REPLY" =~ ^[Yy](es)?$ ]]; then
      sudo rm -rf "$ROOT_HOME/.vim"
      sudo rm -f "$ROOT_HOME/.vimrc"
      sudo cp -r "$HOME/.vim" "$ROOT_HOME/.vim"
      sudo cp "$HOME/.vimrc" "$ROOT_HOME/.vimrc"
    fi
  fi
fi

echo "Done!"
echo "Please restart your terminal or run 'exec bash' to update your PATH"
echo
