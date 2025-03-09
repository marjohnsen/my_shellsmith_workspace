#!/bin/bash
: zsh python

source "$SHELLSMITH_UTILS/safe_symlink.sh"

apt_get_install() {
  # Update system
  sudo apt-get update && sudo apt-get upgrade -y

  # Install Sway
  sudo apt-get install -y \
    sway swaybg swaylock swayidle xwayland libwayland-dev wayland-protocols

  # Audio System
  sudo apt-get install -y \
    pipewire wireplumber pipewire-pulse pavucontrol

  # Clipboard and Notifications
  sudo apt-get install -y \
    wl-clipboard clipman mako-notifier

  # Brightness & Power Control
  sudo apt-get install -y \
    brightnessctl

  # Screenshots, Screen Capture & Wayland Portals
  sudo apt-get install -y \
    grim slurp xdg-desktop-portal xdg-desktop-portal-wlr

  # File Management
  sudo apt-get install -y \
    thunar thunar-archive-plugin file-roller

  # Network & Bluetooth
  sudo apt-get install -y \
    network-manager-gnome blueman bluez

  # Enable PipeWire Services
  systemctl --user enable --now pipewire wireplumber pipewire-pulse
}

build_and_install_wayland_rofi() {
  sudo apt-get build-dep -y rofi
  sudo apt-get install -y libxcb-keysyms1-dev

  BUILD_DIR="$HOME/build/rofi"

  rm -rf "$BUILD_DIR"
  mkdir -p "$BUILD_DIR"

  git clone --recurse-submodules https://github.com/lbonn/rofi.git "$BUILD_DIR"

  meson setup "$BUILD_DIR/build" "$BUILD_DIR" --prefix=/usr/local
  sudo ninja -C "$BUILD_DIR/build" install
}

setup_swayfx() {
  mkdir -p "$HOME/.config/sway"
  mkdir -p "$HOME/.config/mako"
  mkdir -p "$HOME/.config/rofi"

  safe_symlink "$SHELLSMITH_DOTFILES/sway/sway" "$HOME/.config/sway/config"
  safe_symlink "$SHELLSMITH_DOTFILES/sway/mako" "$HOME/.config/mako/config"

  safe_symlink "$SHELLSMITH_MISC/lock_screen.sh" "$HOME/.config/sway/lock_screen.sh"
  safe_symlink "$SHELLSMITH_MISC/wallpaper.jpg" "$HOME/.config/sway/wallpaper.jpg"
  safe_symlink "$SHELLSMITH_MISC/swaybar" "$HOME/.config/sway/swaybar"
  safe_symlink "$SHELLSMITH_MISC/rofi" "$HOME/.config/rofi"
}

apt_get_install
build_and_install_wayland_rofi
setup_swayfx
