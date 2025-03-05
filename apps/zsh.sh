#!/bin/bash

source "$SHELLSMITH_UTILS/safe_symlink.sh"

install_and_setup_zsh() {
  brew upgrade zsh >/dev/null || brew intall zsh
  chsh -s "$(which zsh)"
}

install_and_setup_ohmyzsh() {
  if [ -d "$HOME/.oh-my-zsh/" ]; then
    rm -rf "$HOME/.oh-my-zsh/"
  fi

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

  safe_symlink "$SHELLSMITH_DOTFILES/zshrc" "$HOME/.zshrc"
}

install_plugins() {
  brew install bat

  local plugins_dir=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins

  rm -rf "$plugins_dir" && mkdir -p "$plugins_dir"

  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$plugins_dir/zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$plugins_dir/zsh-syntax-highlighting"
  git clone https://github.com/fdellwing/zsh-bat.git \
    "$plugins_dir/zsh-bat"
}

install_and_setup_p10k() {
  local p10k_dir=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

  if [ -d "$p10k_dir" ]; then
    rm -rf "$p10k_dir"
  fi

  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
}

install_and_setup_zsh
install_and_setup_ohmyzsh
install_plugins
install_and_setup_p10k
