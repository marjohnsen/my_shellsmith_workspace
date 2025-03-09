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
    wl-clipboard clipman mako-notifier libnotify-bin

  # Brightness & Power Control
  sudo apt-get install -y \
    upower brightnessctl

  # Screenshots, Screen Capture & Wayland Portals
  sudo apt-get install -y \
    grim slurp jq xdg-desktop-portal xdg-desktop-portal-wlr

  # File Management
  sudo apt-get install -y \
    thunar thunar-archive-plugin file-roller

  # Network & Bluetooth
  sudo apt-get install -y \
    network-manager blueman bluez
}

system_services() {
  # Enable PipeWire Services
  systemctl --user enable --now pipewire wireplumber pipewire-pulse

  # Setup Network Manager
  sudo systemctl start NetworkManager
  sudo systemctl enable --now NetworkManager

  sudo tee /etc/network/interfaces >/dev/null <<'EOF'
auto lo
iface lo inet loopback
EOF

  sudo tee /etc/NetworkManager/NetworkManager.conf >/dev/null <<'EOF'
[main]
plugins=ifupdown,keyfile
[ifupdown]
managed=true
EOF
  sudo systemctl restart NetworkManager
}

build_and_install_wayland_rofi() {
  sudo apt-get build-dep -y rofi
  sudo apt-get install -y libxcb-keysyms1-dev

  BUILD_DIR="$HOME/build/rofi"

  rm -rf "$BUILD_DIR"
  mkdir -p "$BUILD_DIR"

  local i=0
  until git clone --recurse-submodules https://github.com/lbonn/rofi.git "$BUILD_DIR"; do
    sleep 5
    i=$((i + 1))
    if [ $i -eq 10 ]; then
      echo "Failed to clone rofi repository due to a network issue."
      exit 1
    fi

  done

  meson setup "$BUILD_DIR/build" "$BUILD_DIR" --prefix=/usr/local
  sudo ninja -C "$BUILD_DIR/build" install
}

setup_sway() {
  mkdir -p "$HOME/.config/sway"
  mkdir -p "$HOME/.config/mako"

  safe_symlink "$SHELLSMITH_DOTFILES"/sway/sway "$HOME/.config/sway/config"
  safe_symlink "$SHELLSMITH_DOTFILES"/sway/mako "$HOME/.config/mako/config"

  safe_symlink "$SHELLSMITH_MISC"/sway/lock_screen.sh "$HOME/.config/sway/lock_screen.sh"
  safe_symlink "$SHELLSMITH_MISC"/sway/wallpaper.jpg "$HOME/.config/sway/wallpaper.jpg"
  safe_symlink "$SHELLSMITH_MISC"/sway/swaybar "$HOME/.config/sway/swaybar"
  safe_symlink "$SHELLSMITH_MISC"/sway/rofi "$HOME/.config/rofi"
}

setup_home() {
  mkdir -p "$HOME/Pictures/Screenshots"
  mkdir -p "$HOME/Downloads"
  mkdir -p "$HOME/Documents"
}

apt_get_install
system_services
build_and_install_wayland_rofi
setup_swayfx
