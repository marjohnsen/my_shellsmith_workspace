#!/bin/bash

test_admin_privileges() {
  if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root"
    exit 1
  fi
}

install_brew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "eval '$(/opt/homebrew/bin/brew shellenv)'" >>~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

brew_install() {
  brew tap homebrew/cask-fonts
  brew update
  brew install git
  brew install wget
  brew install curl
  brew install ripgrep
  brew install fd
  brew install fzf
  brew install fuse
  brew install --cask mactex-no-gui
  brew install --cask skim
  brew install --cask firefox
  brew install --cask font-jetbrains-mono-nerd-font
}

test_admin_privileges
install_brew
brew_install
