#!/bin/bash

install_brew() {
  xcode-select --install

  # Add brew to path
  if ! grep -q '/opt/homebrew/bin/brew shellenv' ~/.zprofile; then
    echo -e "#Homebrew\neval '$(/opt/homebrew/bin/brew shellenv)'\n" >>~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  # Update if brew is already installed, else install brew
  if command -v brew &>/dev/null; then
    brew update
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

brew_install() {
  brew upgrade

  FORMULAE=(git wget curl ripgrep fd fzf node)
  CASKS=(firefox font-jetbrains-mono-nerd-font)

  # Install missing formulae
  for pkg in "${FORMULAE[@]}"; do
    brew list "$pkg" &>/dev/null || brew install "$pkg"
  done

  # Install missing casks
  for cask in "${CASKS[@]}"; do
    brew list --cask "$cask" &>/dev/null || brew install --cask "$cask"
  done
}

install_brew
brew_install
