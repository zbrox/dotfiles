#!/usr/bin/env bash

set -e
set -u
set -o pipefail

is_app_installed() {
  type "$1" &>/dev/null
}

if ! is_app_installed tmux; then
  printf "WARNING: \"tmux\" command is not found. \
Install it first\n"
  exit 1
fi

if [ ! -e "$HOME/.tmux/plugins/tpm" ]; then
  printf "WARNING: Cannot find TPM (Tmux Plugin Manager) at default location: \$HOME/.tmux/plugins/tpm.\n"
  printf "Installing TPM\n"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm 2> /dev/null
fi

# Install TPM plugins.
# TPM requires running tmux server, as soon as `tmux start-server` does not work
# create dump __noop session in detached mode, and kill it when plugins are installed
printf "Install TPM plugins\n"
tmux new -d -s __noop >/dev/null 2>&1 || true 
tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "$HOME/.tmux/plugins"
"$HOME"/.tmux/plugins/tpm/bin/install_plugins || true
tmux kill-session -t __noop >/dev/null 2>&1 || true

printf "tmux is now set up\n"