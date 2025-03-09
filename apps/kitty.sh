#!/bin/bash

source "$SHELLSMITH_UTILS/safe_symlink.sh"

build_kitty() {
  sudo apt-get build-dep -y kitty
  sudo apt-get install -y \
    libglfw3 libgl1-mesa-glx mesa-utils libegl1-mesa
  rm -rf "$HOME/.local/kitty.app"
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
  safe_symlink "$HOME/.local/kitty.app/bin/kitty" "/usr/local/bin/kitty"
  safe_symlink "$HOME/.local/kitty.app/bin/kitten" "/usr/local/bin/kitten"

}

configure_kitty() {
  mkdir -p "$HOME/.config/kitty/"
  mkdir -p ~/.local/share/applications

  safe_symlink "$SHELLSMITH_SHARED_DOTFILES/kitty" "$HOME/.config/kitty/kitty.conf"

  cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
  cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/

  sed -i "s|Icon=kitty|Icon=$(readlink -f ~/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png)|" ~/.local/share/applications/kitty*.desktop
  sed -i "s|Exec=kitty|Exec=$(readlink -f ~/.local/kitty.app/bin/kitty)|" ~/.local/share/applications/kitty*.desktop

  sed -i "/\[Desktop Entry\]/a Environment=KITTY_ENABLE_WAYLAND=1" ~/.local/share/applications/kitty*.desktop
}

configure_theme() {
  mkdir -p "$HOME/.config/kitty"
  curl https://raw.githubusercontent.com/dexpota/kitty-themes/master/themes/gruvbox_dark.conf >"$HOME/.config/kitty/theme.conf"
}

build_kitty
#configure_kitty
#configure_theme
