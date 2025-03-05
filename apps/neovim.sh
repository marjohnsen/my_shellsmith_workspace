#!/bin/bash
: python

source "$SHELLSMITH_UTILS/safe_symlink.sh"

brew_install() {
  brew upgrade

  FORMULAE=(imagemagick ghostscript pkg-config lazygit tmux)
  CASKS=(macfuse mactex-no-gui skim)

  # Install missing formulae
  for pkg in "${FORMULAE[@]}"; do
    brew list "$pkg" &>/dev/null || brew install "$pkg"
  done

  # Install missing casks
  for cask in "${CASKS[@]}"; do
    brew list --cask "$cask" &>/dev/null || brew install --cask "$cask"
  done
}

install_dependencies() {
  pipx install jupytext
  sudo npm install -g neovim
}

install_neovim() {
  [ -d "/opt/nvim" ] && sudo rm -rf /opt/nvim ~/.local/share/nvim ~/.cache/nvim
  TMPDIR=$(mktemp -d /tmp/nvim.XXXXXX)
  curl -L -o "$TMPDIR/nvim-macos-arm64.tar.gz" https://github.com/neovim/neovim/releases/download/stable/nvim-macos-arm64.tar.gz
  tar -xzf "$TMPDIR/nvim-macos-arm64.tar.gz" -C "$TMPDIR"
  sudo mkdir -p /opt/nvim
  sudo rm -rf /opt/nvim/*
  sudo mv "$TMPDIR/nvim-macos-arm64/"* /opt/nvim/
  rm -rf "$TMPDIR"
  sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
}

setup_lazyvim() {
  safe_symlink "$SHELLSMITH_SHARED_DOTFILES/nvim" "$HOME/.config/nvim"
}

setup_nvim_pyenv() {
  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"

  latest_stable=$(pyenv install --list | grep -E '^\s*3\.[0-9]+\.[0-9]+$' | tail -1 | xargs)

  if ! pyenv versions --bare | grep "^$latest_stable$"; then
    pyenv install "$latest_stable"
  fi

  if pyenv versions --bare | grep "^neovim$"; then
    pyenv virtualenv-delete -f neovim
  fi

  pyenv virtualenv "$latest_stable" neovim

  "$(pyenv prefix neovim)/bin/python" -m pip install --upgrade pip
  "$(pyenv prefix neovim)/bin/python" -m \
    pip install pynvim cairosvg pnglatex plotly kaleido \
    pyperclip nbformat pillow requests websocket-client \
    jupyter_client jupytext ipykernel notebook
}

brew_install
install_dependencies
install_neovim
setup_lazyvim
setup_nvim_pyenv
