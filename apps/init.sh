#!/bin/bash

set -e

apt_install() {
  sudo apt-get update
  sudo apt-get full-upgrade -y

  # Desktop utils
  sudo apt-get install -y firefox-esr ranger
  # System utils
  sudo apt-get install -y network-manager
  # CLI utils
  sudo apt-get install -y  wget curl bat git wl-clipboard
}

install_node_npm() {
  echo "Installing Node.js LTS (22.x) and npm..."
  curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
  sudo apt install -y nodejs
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

git_setup() {
  git config --global user.name "Marius Johnsen"
  git config --global user.email "marius.johnsen@outlook.com"
  git config --global core.editor "nvim"
  git config --global merge.tool nvimdiff
  git config --global mergetool.nvimdiff.cmd "nvim -d \$LOCAL \$REMOTE \$BASE \$MERGED"
}

generate_ssh_key_pair() {
  KEY_FILE="$HOME/.ssh/id_ed25519"
  
  if [[ -f "$KEY_FILE" ]]; then
    echo ""
    read -p "Do you want to create a new SSH key pair? (y/n): " choice < /dev/tty
    if [[ "$choice" =~ ^[Yy]([Ee][Ss])?$ ]]; then
      rm -f "$KEY_FILE" "$KEY_FILE".pub
      ssh-keygen -t ed25519 -C "marius.johnsen@outlook.com" -f "$KEY_FILE" -N "" -q
      echo "Overwriting existing SSH key pair.."
    fi
  else
    ssh-keygen -t ed25519 -C "marius.johnsen@outlook.com" -f "$KEY_FILE" -N "" -q
    echo "A new SSH key pair was created.."
  fi
}

apt_install
install_node_npm
git_setup
generate_ssh_key_pair
install_fonts
