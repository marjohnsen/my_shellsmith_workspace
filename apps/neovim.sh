#!/bin/bash
: python

source "$SHELLSMITH_UTILS/safe_symlink.sh"

install_dependencies() {
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm -rf lazygit lazygit.tar.gz

  sudo apt-get build-dep -y neovim
  sudo apt-get install -y build-essential wl-clipboard ripgrep fd-find fzf texlive biber latexmk fuse imagemagick libmagickwand-dev unzip

  pipx install jupytext &
  pipx ensurepath

  sudo npm install -g neovim
}

install_neovim() {
  tmp_dir=$(mktemp -d /tmp/nvim.XXXXXX)

  sudo rm -rf /opt/nvim ~/.local/share/nvim ~/.cache/nvim
  curl -Lo "$tmp_dir/nvim.appimage" https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.appimage
  chmod u+x "$tmp_dir/nvim.appimage"

  env -C "$tmp_dir" "$tmp_dir/nvim.appimage" --appimage-extract
  sudo mv "$tmp_dir/squashfs-root" /opt/nvim
  sudo ln -sf /opt/nvim/AppRun /usr/local/bin/nvim

  rm -rf "$tmp_dir"
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

install_dependencies
install_neovim
setup_lazyvim
# setup_nvim_pyenv
