#!/bin/bash

setup_ssh_keys() {
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"

  local equinor_key="$HOME/.ssh/equinor"
  local private_key="$HOME/.ssh/private"
  local ssh_config="$HOME/.ssh/config"

  rm -f "$equinor_key" "$equinor_key.pub" "$private_key" "$private_key.pub" "$ssh_config"
  ssh-keygen -t rsa -b 4096 -C "mariuj@equinor.com" -f "$equinor_key" -N "" -q
  ssh-keygen -t rsa -b 4096 -C "marius.johnsen@outlook.com" -f "$private_key" -N "" -q
  chmod 600 "$equinor_key" "$equinor_key.pub" "$private_key" "$private_key.pub"
  echo 'Generated SSH keys..'

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
  echo 'Generated SSH config..'
}

setup_ssh_agent() {
  if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)"
    echo 'Starting SSH agent..'
  else
    echo 'SSH agent is already running..'
  fi

  ssh-add -d "$HOME/.ssh/equinor" 2>/dev/null
  ssh-add "$HOME/.ssh/equinor" 2>/dev/null
  echo 'Added new work key..'

  ssh-add -d "$HOME/.ssh/private" 2>/dev/null
  ssh-add "$HOME/.ssh/private" 2>/dev/null
  echo 'Added new private key..'
}

setup_git_config() {
  git config --global user.name "Marius Johnsen"
  git config --global user.email "mariuj@equinor.com"
  git config --global core.editor "nvim"
  git config --global merge.tool nvimdiff
  git config --global mergetool.nvimdiff.cmd "nvim -d \$LOCAL \$REMOTE \$BASE \$MERGED"
  echo 'Global git config set..'
}

setup_git_template_hook() {
  local template_dir="$HOME/.git-template"
  mkdir -p "$template_dir/hooks"

  cat >"$template_dir/hooks/post-checkout" <<'EOF'
#!/bin/sh
remote_url=$(git config --get remote.origin.url)
if echo "$remote_url" | grep -q "git@private:"; then
  git config user.email "marius.johnsen@outlook.com"
  echo "Local email set to private (marius.johnsen@outlook.com)"
else
  echo "Local email remains equinor (mariuj@equinor.com)"
fi
EOF

  chmod +x "$template_dir/hooks/post-checkout"
  git config --global init.templateDir "$template_dir"
  echo 'Global git template hook set..'
}

setup_ssh_keys
setup_ssh_agent
setup_git_config
setup_git_template_hook
