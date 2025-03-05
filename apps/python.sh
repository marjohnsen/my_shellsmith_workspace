#!/bin/bash
: zsh

install_build_dependencies() {
  FORMULAE=(ncurses openssl readline sqlite3 xz zlib tcl-tk pipx)
  for pkg in "${FORMULAE[@]}"; do
    brew upgrade "$pkg" &>/dev/null || brew install "$pkg"
  done
}

install_pyenv() {
  rm -rf "$HOME/.pyenv"
  curl https://pyenv.run | bash
  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
  pyenv update
}

install_latest_stable() {
  latest_stable=$(pyenv install --list | grep -E '^\s*3\.[0-9]+\.[0-9]+$' | tail -1 | xargs)
  pyenv install "$latest_stable"
  pyenv global "$latest_stable"
}

install_build_dependencies
install_pyenv
install_latest_stable
