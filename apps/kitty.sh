#!/bin/bash

source "$SHELLSMITH_UTILS/safe_symlink.sh"

install_kitty() {
  sudo apt-get install kitty -y
}

configure_kitty() {
  mkdir -p "$HOME/.config/kitty/"
  safe_symlink "$SHELLSMITH_SHARED_DOTFILES/kitty" "$HOME/.config/kitty/kitty.conf"
}

configure_theme() {
  mkdir -p "$HOME/.config/kitty"
  curl https://raw.githubusercontent.com/dexpota/kitty-themes/master/themes/gruvbox_dark.conf >"$HOME/.config/kitty/theme.conf"
}

install_kitty
configure_kitty
configure_theme
