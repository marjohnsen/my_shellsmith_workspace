#!/bin/bash

set -e

source "$SHELLSMITH_UTILS/safe_symlink.sh"

install_zsh() {
  sudo apt-get update
  sudo apt-get install -y zsh git bat
  sudo chsh -s /usr/bin/zsh $(logname)
}

install_ohmyzsh() {
  [ -d "$HOME/.oh-my-zsh" ] && rm -rf "$HOME/.oh-my-zsh"
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
  safe_symlink "$SHELLSMITH_DOTFILES/zshrc" "$HOME/.zshrc"
}

install_plugins() {
  sudo apt-get install -y bat
  local plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

  rm -rf "$plugins_dir"
  mkdir -p "$plugins_dir"

  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$plugins_dir/zsh-autosuggestions"
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugins_dir/zsh-syntax-highlighting"
  git clone --depth=1 https://github.com/fdellwing/zsh-bat.git "$plugins_dir/zsh-bat"
}

install_p10k() {
  local p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

  [ -d "$p10k_dir" ] && rm -rf "$p10k_dir"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
}

install_zsh
install_ohmyzsh
install_plugins
install_p10k
