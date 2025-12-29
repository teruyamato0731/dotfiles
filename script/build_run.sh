#!/usr/bin/env bash
# Build and run the Docker image for the installation test and preview environment.
set -euo pipefail

# Constants
readonly IMAGE_NAME="dotfiles-preview"
readonly DOCKERFILE_PATH=".devcontainer/Dockerfile"

info() {
  printf '\033[32m[ INFO] %s:%s:\n  %s\033[m\n' "${BASH_SOURCE[0]}" "${BASH_LINENO[0]}" "$1"
}
die() {
  printf '\033[31m[ERROR] %s:%s:\n  %s\033[m\n' "${BASH_SOURCE[0]}" "${BASH_LINENO[0]}" "$1" >&2
  exit "${2:-1}"
}

main() {
  cd "$(dirname "$0")/.." || die "Failed to change directory to project root."
  info "Building Docker image: ${IMAGE_NAME}"
  docker build -t "${IMAGE_NAME}" -f "${DOCKERFILE_PATH}" . || die "Failed to build Docker image."

  info "Running Docker container from image: ${IMAGE_NAME}"
  docker run --rm -it "${IMAGE_NAME}" || die "Failed to run Docker container."
}

main "$@"
