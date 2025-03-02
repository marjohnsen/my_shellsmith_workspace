#!/bin/bash

apt_install() {
  sudo apt-get update
  sudo apt-get full-upgrade -y

  # Desktop utils
  sudo apt-get install -y firefox-esr ranger
  # System utils
  sudo apt-get install -y network-manager
  # CLI utils
  sudo apt-get install -y  wget curl batcat git wl-clipboard
}

install_node_npm() {
  echo "Installing Node.js LTS (22.x) and npm..."
  curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
  sudo apt install -y nodejs
} 

git_config() {
  git config --global user.name "Marius Johnsen"
  git config --global user.email "marius.johnsen@outlook.com"
  git config --global core.editor "nvim"
  git config --global merge.tool nvimdiff
  git config --global mergetool.nvimdiff.cmd "nvim -d \$LOCAL \$REMOTE \$BASE \$MERGED"
}

install_fonts() {
  font_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
  font_name="JetBrainsMono"
  font_dir="/usr/local/share/fonts"

  sudo mkdir -p "$font_dir"
  wget -q --show-progress "$font_url" -O "$font_name.tar.xz"
  sudo tar -xf "$font_name.tar.xz" -C "$font_dir"
  sudo fc-cache -fv >/dev/null
  rm "$font_name.tar.xz"

  if fc-list | grep -i "JetBrainsMono" >/dev/null; then
    echo "$font_name Nerd Font installed successfully!"
  else
    echo "Installation failed!"
    exit 1
  fi
}

apt_install
install_node_npm
git_config
install_fonts
