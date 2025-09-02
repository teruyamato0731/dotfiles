#!/usr/bin/env bash
set -euo pipefail
#
# dotfiles installation script
# This script sets up the development environment by installing necessary packages and tools.
# The following commands are required to run this script:
# - sudo
# - git

# shellcheck disable=SC2034
DEBIAN_FRONTEND=noninteractive

# Logging functions
info() {
  printf '\033[32m[Info] %s:\n  %s\033[m\n' "$0:${BASH_LINENO[0]}" "$*"
}
warn() {
  printf '\033[33m[Warning] %s:\n  %s\033[m\n' "$0:${BASH_LINENO[0]}" "$*" >&2
}
err_exit() {
  printf '\033[31m[Error] %s:\n  %s\033[m\n' "$0:${BASH_LINENO[0]}" "$*" >&2
  exit 1
}

install_tools() {
  info "Installing CLI tools and utilities..."
  sudo apt-get update
  sudo apt-get install -y \
    bash-completion \
    curl \
    unzip \
    tree \
    htop \
    bat \
    ripgrep \
    fd-find \
    gh \
    jq
}

install_ghq() {
  if ! command -v ghq &>/dev/null; then
    info "Installing ghq..."
    curl -sL -o ghq.zip "https://github.com/x-motemen/ghq/releases/download/v1.8.0/ghq_linux_amd64.zip"
    unzip ./ghq.zip
    sudo install -D ghq_linux_amd64/ghq /usr/local/bin/ghq
    sudo cp ghq_linux_amd64/misc/bash/_ghq /usr/share/bash-completion/completions/_ghq
    rm -rf ./ghq.zip ./ghq_linux_amd64
  else
    info "ghq is already installed."
  fi
}

install_fzf() {
  if ! command -v fzf &>/dev/null; then
    info "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.local/bin/.fzf
    git clone --depth 1 https://github.com/junegunn/fzf-git.sh.git ~/.local/bin/.fzf-git
    ~/.local/bin/.fzf/install --xdg --key-bindings --completion --update-rc
  else
    info "fzf is already installed."
  fi
}

main() {
  install_tools
  install_ghq
  install_fzf
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
