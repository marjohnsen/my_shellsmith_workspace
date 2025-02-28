#!/bin/bash

install_brew() {
  xcode-select --install

  # Add brew to path
  if ! grep -q '/opt/homebrew/bin/brew shellenv' ~/.zprofile; then
    echo -e "#Homebrew\neval '$(/opt/homebrew/bin/brew shellenv)'\n" >>~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  # Update if brew is already installed, else install brew
  if command -v brew &>/dev/null; then
    brew update
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

brew_install() {
  brew upgrade

  FORMULAE=(git wget curl ripgrep fd fzf node)
  CASKS=(firefox font-jetbrains-mono-nerd-font)

  # Install missing formulae
  for pkg in "${FORMULAE[@]}"; do
    brew list "$pkg" &>/dev/null || brew install "$pkg"
  done

  # Install missing casks
  for cask in "${CASKS[@]}"; do
    brew list --cask "$cask" &>/dev/null || brew install --cask "$cask"
  done
}

git_setup() {
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"

  local equinor_key="$HOME/.ssh/equinor"
  local private_key="$HOME/.ssh/private"
  local ssh_config="$HOME/.ssh/config"

  # Generate SSH keys for Equinor and Work
  rm -f "$equinor_key" "$equinor_key.pub" "$private_key" "$private_key.pub" "$ssh_config"
  ssh-keygen -t rsa -b 4096 -C "mariuj@equinor.com" -f "$equinor_key" -N "" -q
  ssh-keygen -t rsa -b 4096 -C "marius.johnsen@outlook.com" -f "$private_key" -N "" -q
  chmod 600 "$equinor_key" "$equinor_key.pub" "$private_key" "$private_key.pub"

  # Create ssh config file with aliases for the keys
  cat >"$ssh_config" <<EOF
Host equinor
  HostName github.com
  User git
  IdentityFile ~/.ssh/equinor

Host private
  HostName github.com
  User git
  IdentityFile ~/.ssh/private
EOF

  chmod 600 "$ssh_config"

  # Ensure an ssh-agent is running
  if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)"
  fi

  # Check if the Equinor key (identified by its comment) is loaded; if not, add it.
  if ! ssh-add -l 2>/dev/null | grep -q "mariuj@equinor.com"; then
    ssh-add "$HOME/.ssh/equinor"
  fi

  # Check if the Work key (identified by its comment) is loaded; if not, add it.
  if ! ssh-add -l 2>/dev/null | grep -q "marius.johnsen@outlook.com"; then
    ssh-add "$HOME/.ssh/private"
  fi

  # Configure Git
  git config --global user.name "Marius Johnsen"
  git config --global user.email "mariuj@equinor.com"
  git config --global core.editor "nvim"
  git config --global merge.tool nvimdiff
  git config --global mergetool.nvimdiff.cmd "nvim -d \$LOCAL \$REMOTE \$BASE \$MERGED"

  echo "SSH keys, ~/.ssh/config, and Git config have been created/updated."
}

install_brew
brew_install
git_setup
