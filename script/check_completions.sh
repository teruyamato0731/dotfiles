#!/usr/bin/env bash
set -euo pipefail

data_dir="${XDG_DATA_HOME:-${HOME}/.local/share}"

for tool in mise gh ghq lazygit bat rg fd btm uv uvx yazi ya; do
  for completion in "${data_dir}/bash-completion/completions/${tool}" \
    "${data_dir}/zsh/site-functions/_${tool}"; do
    if [[ ! -s "${completion}" ]]; then
      printf 'Missing or empty completion: %s\n' "${completion}" >&2
      exit 1
    fi
  done
done
