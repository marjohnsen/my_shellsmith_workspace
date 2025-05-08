#!/bin/bash
: kitty

source "$SHELLSMITH_UTILS/safe_symlink.sh"

brew_install() {
  brew upgrade
  brew list --cask "aerospace" &>/dev/null || brew install --cask "nikitabobko/tap/aerospace"
}

setup_aerospace() {
  safe_symlink "$SHELLSMITH_DOTFILES/aerospace/aerospace.toml" "$HOME/.aerospace.toml"
}

brew_install
setup_aerospace
