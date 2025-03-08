#!/bin/bash
: zsh python

source "$SHELLSMITH_UTILS/safe_symlink.sh"
source "$SHELLSMITH_UTILS/meson_build_and_ninja_install.sh"

apt_get_install() {
  # Update system
  sudo apt-get update && sudo apt-get upgrade -y

  # Install Sway
  sudo apt-get install -y \
    sway swaybg swaylock swayidle xwayland waybar

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

build_and_install_wl_rofi() {
  meson_build_and_ninja_install "https://github.com/lbonn/rofi.git"
}

apt_get_install
