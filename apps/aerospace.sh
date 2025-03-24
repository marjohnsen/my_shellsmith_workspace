#!/bin/bash

source "$SHELLSMITH_UTILS/safe_symlink.sh"

brew_install() {
  brew upgrade

  CASKS=('nikitabobko/tap/aerospace')

  Install missing casks
  for cask in "${CASKS[@]}"; do
    brew list --cask "$cask" &>/dev/null || brew install --cask "$cask"
  done
}

setup_aerospace() {
  safe_symlink "$SHELLSMITH_SHARED_DOTFILES/aerospace/aerospace.toml" "$HOME/.aerospace.toml"
}

brew_install
setup_aerospace
