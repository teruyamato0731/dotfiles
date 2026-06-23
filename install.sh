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

get_dotfiles_dir() {
  # Decide dotfiles directory based on how the script was invoked.
  # - If DOTFILES_DIR env is set, prefer it.
  # - If piped or redirected, fall back to $HOME/dotfiles.
  # - Otherwise, use the directory containing this script.
  if [ -n "${DOTFILES_DIR:-}" ]; then
    printf '%s\n' "${DOTFILES_DIR}"
    return 0
  fi

  local src
  src="${BASH_SOURCE[0]:-$0}"
  if [[ "${src}" == /dev/fd/* || "${src}" == /proc/* || ! -e "${src}" ]]; then
    printf '%s\n' "${HOME}/dotfiles"
    return 0
  fi

  cd -P "$(dirname "${src}")" >/dev/null 2>&1
  pwd
}

DOTFILES_DIR="$(get_dotfiles_dir)"
CACHE_DIR="${XDG_CACHE_HOME:-${HOME}/.cache}/dotfiles"
APT_PACKAGES=(
  bash-completion
  git
  curl
  unzip
  tree
  htop
  gh
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
  repo_url="https://github.com/teruyamato0731/dotfiles.git"
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

install_mise_tools() {
  info "Installing mise-managed tools..."
  local mise
  local mise_config
  mise="$(mise_bin)" || err_exit "mise is not installed."
  mise_config="${HOME}/.config/mise/config.toml"
  "${mise}" trust "${mise_config}"
  # Install from the global mise config, independent of the dotfiles repo cwd.
  "${mise}" install -C "${HOME}"
}

install_tio() {
  # snap がある場合のみ
  if command -v snap &>/dev/null; then
    if ! command -v tio &>/dev/null; then
      info "Installing tio..."
      sudo snap install tio --classic
    fi
  fi
}

install_uv() {
  if ! command -v uv &>/dev/null; then
    info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
  fi
}

install_fonts() {
  info "Installing fonts..."
  local font_cache_dir="${CACHE_DIR}/fonts"
  local font_dir="${HOME}/.local/share/fonts"
  local version="v2.0.0"
  local moralerspace_zip="${font_cache_dir}/Moralerspace_${version}.zip"
  local moralerspace_hw_zip="${font_cache_dir}/MoralerspaceHW_${version}.zip"
  local extract_dir
  local installed_font

  mkdir -p "${font_cache_dir}" "${font_dir}"

  installed_font="$(find "${font_dir}" -maxdepth 1 -name 'Moralerspace*.ttf' -print -quit)"
  if [ -n "${installed_font}" ]; then
    info "Moralerspace fonts are already installed."
    return 0
  fi

  if [ ! -f "${moralerspace_zip}" ]; then
    curl -fsSLo "${moralerspace_zip}" "https://github.com/yuru7/moralerspace/releases/download/${version}/Moralerspace_${version}.zip"
  fi
  if [ ! -f "${moralerspace_hw_zip}" ]; then
    curl -fsSLo "${moralerspace_hw_zip}" "https://github.com/yuru7/moralerspace/releases/download/${version}/MoralerspaceHW_${version}.zip"
  fi

  extract_dir="$(mktemp -d)"
  unzip -q "${moralerspace_zip}" -d "${extract_dir}"
  unzip -q "${moralerspace_hw_zip}" -d "${extract_dir}"
  find "${extract_dir}" -name '*.ttf' -exec mv -f {} "${font_dir}/" \;
  rm -rf -- "${extract_dir}"
  fc-cache -f "${font_dir}" >/dev/null 2>&1 || true
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
  # .gitconfig.custom
  ln -nfs "${DOTFILES_DIR}/config/git/.gitconfig.custom" "${HOME}/.gitconfig.custom"
  # .bashrc.custom
  ln -nfs "${DOTFILES_DIR}/config/bash/.bashrc.custom" "${HOME}/.bashrc.custom"
  if ! grep -q 'source ~/.bashrc.custom' "${HOME}/.bashrc"; then
    echo '[ -f ~/.bashrc.custom ] && source ~/.bashrc.custom' >> "${HOME}/.bashrc"
  fi
  # git ignore global
  mkdir -p "${HOME}/.config/git"
  ln -nfs "${DOTFILES_DIR}/config/git/ignore" "${HOME}/.config/git/ignore"
  # mise config
  mkdir -p "${HOME}/.config/mise"
  ln -nfs "${DOTFILES_DIR}/config/mise/config.toml" "${HOME}/.config/mise/config.toml"
}

post_instructions() {
  info "Dotfiles installation and setup completed successfully."

  if ! git config --global --get-all include.path | grep -qx -- "${HOME}/.gitconfig.custom"; then
    echo "Please run the following command to include the custom git configuration:"
    printf "  git config --global --add include.path '~/.gitconfig.custom'\n"
  fi
}

main() {
  install_apt_packages
  setup
  install_mise
  install_symlinks
  install_mise_tools
  install_tio
  install_uv
  install_fonts
  post_instructions
}

if [[ -z "${BASH_SOURCE[0]:-}" || "${BASH_SOURCE[0]:-}" == "$0" ]]; then
  main "$@"
fi
