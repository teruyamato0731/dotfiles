#!/usr/bin/env bash
set -euo pipefail
#
# dotfiles installation script
# This script sets up the development environment by installing necessary packages and tools.
# The following commands are required to run this script:
#   - sudo
#   - apt-get
# Usage:
#   ./install.sh or DOTFILES_DIR=/path/to/dotfiles ./install.sh
# After running the script, please execute the following command:
#   `git config --global include.path "${HOME}/.gitconfig.custom"`

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

get_dotfiles_dir() {
  # Decide dotfiles directory based on how the script was invoked.
  # - If DOTFILES_DIR env is set, prefer it.
  # - If piped execution, error out.
  # - Otherwise, use the directory containing this script.
  if [ -n "${DOTFILES_DIR:-}" ]; then
    printf '%s\n' "${DOTFILES_DIR}"
    return 0
  fi

  local src
  src="${BASH_SOURCE[0]:-$0}"
  if [[ "${src}" == /dev/fd/* || "${src}" == /proc/* ]]; then
    err_exit "Detected piped execution; please set DOTFILES_DIR and retry."
  fi

  cd -P "$(dirname "${src}")" >/dev/null 2>&1
  pwd
}

# shellcheck disable=SC2034
DEBIAN_FRONTEND=noninteractive

DOTFILES_DIR="$(get_dotfiles_dir)"

install_tools() {
  info "Installing CLI tools and utilities..."
  sudo apt-get update
  sudo apt-get install -y \
    bash-completion \
    git \
    curl \
    unzip \
    tree \
    htop \
    bat \
    ripgrep \
    fd-find \
    gh \
    jq
  sudo ln -nfs "$(which batcat)" /usr/local/bin/bat
  sudo ln -nfs "$(which fdfind)" /usr/local/bin/fd
}

setup() {
  repo_url="https://github.com/teruyamato0731/dotfiles.git"
  if [ ! -d "${DOTFILES_DIR}" ]; then
    # Clone dotfiles if missing
    warn "DOTFILES_DIR not found; cloning ${repo_url} into ${DOTFILES_DIR}."
    git clone --depth 1 "${repo_url}" "${DOTFILES_DIR}" || err_exit "git clone failed: ${repo_url} -> ${DOTFILES_DIR}"
  fi
  mkdir -p "${DOTFILES_DIR}/tmp"
  mkdir -p "${DOTFILES_DIR}/backup"
  cd "${DOTFILES_DIR}"
}

install_ghq() {
  if ! command -v ghq &>/dev/null; then
    info "Installing ghq..."
    curl -sL -o ./tmp/ghq.zip "https://github.com/x-motemen/ghq/releases/download/v1.8.0/ghq_linux_amd64.zip"
    unzip ./tmp/ghq.zip -d tmp
    sudo install -D ./tmp/ghq_linux_amd64/ghq /usr/local/bin/ghq
    sudo cp ./tmp/ghq_linux_amd64/misc/bash/_ghq /usr/share/bash-completion/completions/_ghq
    rm -rf ./tmp/ghq*
  else
    info "ghq is already installed."
  fi
}

install_fzf() {
  if ! command -v fzf &>/dev/null; then
    info "Installing fzf..."
    ghq get --shallow "https://github.com/junegunn/fzf.git"
    ghq get --shallow "https://github.com/junegunn/fzf-git.sh.git"
    "$(ghq root)/github.com/junegunn/fzf/install" --xdg --key-bindings --completion --no-update-rc
  else
    info "fzf is already installed."
  fi
}

install_btm() {
  if ! command -v btm &>/dev/null; then
    info "Installing btm..."
    curl -sLo ./tmp/bottom.deb "https://github.com/ClementTsang/bottom/releases/download/0.11.1/bottom_0.11.1-1_amd64.deb"
    sudo dpkg -i ./tmp/bottom.deb
  fi
}

install_symlinks() {
  info "Setting up symlinks for dotfiles..."
  # dotfiles directory
  if [ ! -d "$(ghq root)/github.com/teruyamato0731/dotfiles" ]; then
    mkdir -p "$(ghq root)/github.com/teruyamato0731"
    ln -nfs "${DOTFILES_DIR}" "$(ghq root)/github.com/teruyamato0731/dotfiles"
  fi
  # .gitconfig.custom
  ln -nfs "${DOTFILES_DIR}/config/git/.gitconfig.custom" "${HOME}/.gitconfig.custom"
  # .bashrc.custom
  ln -nfs "${DOTFILES_DIR}/config/bash/.bashrc.custom" "${HOME}/.bashrc.custom"
  if ! grep -q 'source ~/.bashrc.custom' "${HOME}/.bashrc"; then
      cat << 'EOF' >> "${HOME}/.bashrc"
# Load custom dotfiles if available
[ -f ~/.bashrc.custom ] && source ~/.bashrc.custom
EOF
  fi
}

post_instructions() {
  info "Dotfiles installation and setup completed successfully."

  if ! git config --global --get-all include.path | grep -qx -- "${HOME}/.gitconfig.custom"; then
    echo "Please run the following command to include the custom git configuration:"
    printf '  `git config --global include.path \"${HOME}/.gitconfig.custom`\n'
  fi
}

main() {
  install_tools
  setup
  install_ghq
  install_fzf
  install_btm
  install_symlinks
  post_instructions
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
