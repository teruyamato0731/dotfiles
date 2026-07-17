#!/usr/bin/env bash
set -euo pipefail
#
# dotfiles installation script
# This script sets up the development environment by installing necessary packages and tools.
# The following commands are required to run this script:
#   - sudo
#   - apt-get
# Usage:
#   ./install.sh [dev|host]
# After running the script, please execute the following command:
#   git config --global include.path '~/.gitconfig.custom'

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

usage() {
  cat <<EOF
Usage: $0 [profile]

Profiles:
  dev   CLI-focused development environment (default)
  host  dev plus fonts and tio for a physical Ubuntu host
EOF
}

DOTFILES_DIR="${HOME}/dotfiles"
CACHE_DIR="${XDG_CACHE_HOME:-${HOME}/.cache}/dotfiles"
APT_PACKAGES=(
  bash-completion
  git
  curl
  file
  unzip
  7zip
  tree
  htop
  jq
  build-essential
  cmake
  libgtest-dev
  ccache
)

install_apt_packages() {
  info "Installing apt packages..."
  sudo apt-get update
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${APT_PACKAGES[@]}"
}

setup() {
  local repo_url="https://github.com/teruyamato0731/dotfiles.git"
  if [ ! -d "${DOTFILES_DIR}" ]; then
    # Clone dotfiles if missing
    warn "DOTFILES_DIR not found; cloning ${repo_url} into ${DOTFILES_DIR}."
    git clone --depth 1 "${repo_url}" "${DOTFILES_DIR}" || err_exit "git clone failed: ${repo_url} -> ${DOTFILES_DIR}"
  fi
  mkdir -p "${CACHE_DIR}"
  cd "${DOTFILES_DIR}"
}

mise_bin() {
  if command -v mise >/dev/null 2>&1; then
    command -v mise
    return 0
  fi
  if [ -x "${HOME}/.local/bin/mise" ]; then
    printf '%s\n' "${HOME}/.local/bin/mise"
    return 0
  fi
  return 1
}

install_mise() {
  if mise_bin >/dev/null 2>&1; then
    info "mise is already installed."
    return 0
  fi

  info "Installing mise..."
  curl -fsSL https://mise.run | MISE_QUIET=1 sh
}

install_symlinks() {
  info "Setting up symlinks for dotfiles..."
  local ghq_root
  ghq_root="$(git config --get ghq.root || true)"
  ghq_root="${ghq_root:-${HOME}/ghq}"
  # dotfiles directory
  if [ ! -d "${ghq_root}/github.com/teruyamato0731/dotfiles" ]; then
    mkdir -p "${ghq_root}/github.com/teruyamato0731"
    ln -nfs "${DOTFILES_DIR}" "${ghq_root}/github.com/teruyamato0731/dotfiles"
  fi
  mkdir -p "${HOME}/.config"
  # mise config
  ln -nfs "${DOTFILES_DIR}/.config/mise" "${HOME}/.config/mise"
}

bootstrap_mise() {
  info "Applying mise bootstrap configuration..."
  local profile="$1"
  local mise
  local mise_config_dir
  mise="$(mise_bin)" || err_exit "mise is not installed."
  mise_config_dir="${HOME}/.config/mise"
  "${mise}" trust "${mise_config_dir}/config.toml"
  "${mise}" trust "${mise_config_dir}/config.${profile}.toml"
  "${mise}" -C "${HOME}" -E "${profile}" bootstrap --yes
}

post_instructions() {
  info "Dotfiles installation and setup completed successfully."

  if ! git config --global --get-all include.path | grep -qx -- "${HOME}/.gitconfig.custom"; then
    echo "Please run the following command to include the custom git configuration:"
    printf "  git config --global --add include.path '~/.gitconfig.custom'\n"
  fi
}

main() {
  local profile="${1:-dev}"

  if [ "$#" -gt 1 ]; then
    usage
    err_exit "Expected at most one profile argument."
  fi

  case "${profile}" in
    (dev|host)
      ;;
    (-h|--help)
      usage
      return 0
      ;;
    (*)
      usage
      err_exit "Unknown profile: ${profile}"
      ;;
  esac

  install_apt_packages
  setup
  install_mise
  install_symlinks
  bootstrap_mise "${profile}"
  post_instructions
}

if [[ -z "${BASH_SOURCE[0]:-}" || "${BASH_SOURCE[0]:-}" == "$0" ]]; then
  main "$@"
fi
