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
  file
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

install_completion_file() {
  local src="$1"
  local dest="$2"

  if [ -f "${src}" ]; then
    cp -f "${src}" "${dest}"
  else
    warn "Completion file not found: ${src}"
  fi
}

install_bash_completions() {
  info "Installing bash completions..."
  local mise
  local completion_dir
  local ghq_bin
  local bat_bin
  local rg_bin
  local fd_bin
  local btm_bin
  local uv_bin
  local uvx_bin
  local yazi_bin

  mise="$(mise_bin)" || err_exit "mise is not installed."
  completion_dir="${XDG_DATA_HOME:-${HOME}/.local/share}/bash-completion/completions"
  mkdir -p "${completion_dir}"

  "${mise}" completion bash --include-bash-completion-lib > "${completion_dir}/mise"

  ghq_bin="$("${mise}" which ghq 2>/dev/null || true)"
  if [ -n "${ghq_bin}" ]; then
    install_completion_file "$(dirname "${ghq_bin}")/misc/bash/_ghq" "${completion_dir}/ghq"
  else
    warn "ghq is not installed by mise; skipping ghq completion."
  fi

  bat_bin="$("${mise}" which bat 2>/dev/null || true)"
  if [ -n "${bat_bin}" ]; then
    install_completion_file "$(dirname "${bat_bin}")/autocomplete/bat.bash" "${completion_dir}/bat"
  else
    warn "bat is not installed by mise; skipping bat completion."
  fi

  rg_bin="$("${mise}" which rg 2>/dev/null || true)"
  if [ -n "${rg_bin}" ]; then
    install_completion_file "$(dirname "${rg_bin}")/complete/rg.bash" "${completion_dir}/rg"
  else
    warn "rg is not installed by mise; skipping rg completion."
  fi

  fd_bin="$("${mise}" which fd 2>/dev/null || true)"
  if [ -n "${fd_bin}" ]; then
    install_completion_file "$(dirname "${fd_bin}")/autocomplete/fd.bash" "${completion_dir}/fd"
  else
    warn "fd is not installed by mise; skipping fd completion."
  fi

  btm_bin="$("${mise}" which btm 2>/dev/null || true)"
  if [ -n "${btm_bin}" ]; then
    install_completion_file "$(dirname "${btm_bin}")/completion/btm.bash" "${completion_dir}/btm"
  else
    warn "btm is not installed by mise; skipping btm completion."
  fi

  uv_bin="$("${mise}" which uv 2>/dev/null || true)"
  if [ -n "${uv_bin}" ]; then
    "${uv_bin}" generate-shell-completion bash > "${completion_dir}/uv"
  else
    warn "uv is not installed by mise; skipping uv completion."
  fi

  uvx_bin="$("${mise}" which uvx 2>/dev/null || true)"
  if [ -n "${uvx_bin}" ]; then
    "${uvx_bin}" --generate-shell-completion bash > "${completion_dir}/uvx"
  else
    warn "uvx is not installed by mise; skipping uvx completion."
  fi

  yazi_bin="$("${mise}" which yazi 2>/dev/null || true)"
  if [ -n "${yazi_bin}" ]; then
    install_completion_file "$(dirname "${yazi_bin}")/completions/yazi.bash" "${completion_dir}/yazi"
    install_completion_file "$(dirname "${yazi_bin}")/completions/ya.bash" "${completion_dir}/ya"
  else
    warn "yazi is not installed by mise; skipping yazi completion."
  fi
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

download_if_missing() {
  local url="$1"
  local dest="$2"
  local tmp

  if [ -f "${dest}" ]; then
    return 0
  fi

  tmp="$(mktemp "${dest}.tmp.XXXXXX")"
  if curl -fsSLo "${tmp}" "${url}"; then
    mv -f "${tmp}" "${dest}"
  else
    rm -f "${tmp}"
    return 1
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

  mkdir -p "${font_cache_dir}" "${font_dir}"

  if [ -f "${font_dir}/MoralerspaceNeon-Regular.ttf" ] &&
     [ -f "${font_dir}/MoralerspaceNeonHW-Regular.ttf" ]; then
    info "Moralerspace fonts are already installed."
    return 0
  fi

  download_if_missing \
    "https://github.com/yuru7/moralerspace/releases/download/${version}/Moralerspace_${version}.zip" \
    "${moralerspace_zip}"
  download_if_missing \
    "https://github.com/yuru7/moralerspace/releases/download/${version}/MoralerspaceHW_${version}.zip" \
    "${moralerspace_hw_zip}"

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
  # yazi config
  mkdir -p "${HOME}/.config/yazi"
  ln -nfs "${DOTFILES_DIR}/config/yazi/init.lua" "${HOME}/.config/yazi/init.lua"
  ln -nfs "${DOTFILES_DIR}/config/yazi/yazi.toml" "${HOME}/.config/yazi/yazi.toml"
  ln -nfs "${DOTFILES_DIR}/config/yazi/keymap.toml" "${HOME}/.config/yazi/keymap.toml"
  ln -nfs "${DOTFILES_DIR}/config/yazi/plugins" "${HOME}/.config/yazi/plugins"
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
  install_bash_completions
  install_tio
  install_fonts
  post_instructions
}

if [[ -z "${BASH_SOURCE[0]:-}" || "${BASH_SOURCE[0]:-}" == "$0" ]]; then
  main "$@"
fi
