#!/usr/bin/env bash
set -euo pipefail
# 
# dotfiles symlink script
# This script creates symlinks for the dotfiles in the home directory.

. "$(dirname "${BASH_SOURCE[0]}")/../install.sh"

info "Creating symlinks for dotfiles..."

mkdir -p "$(ghq root)/github.com/teruyamato0731"
ln -nfs "$DOTFILES_DIR" "$(ghq root)/github.com/teruyamato0731/dotfiles"
