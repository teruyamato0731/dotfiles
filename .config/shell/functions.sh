# shellcheck shell=bash
# Functions that must run in the current shell or are shared by Bash and zsh.

# cd to a ghq repository, or open it in VS Code with Ctrl-O.
gcd() {
  local dir
  dir="$(ghq list | fzf +m \
    --query "${1:-}" \
    --select-1 \
    --preview "cd $(ghq root) && bat --color=always --style=header,grid,numbers --line-range :200 {}/README* 2> /dev/null || tree -C {}" \
    --header 'Press Enter to cd, Ctrl-O to open in code' --color header:italic \
    --bind 'ctrl-o:become(d="$(ghq root)"/{}; w=$(fd -d 1 -e code-workspace . "$d" | head -n 1); code "${w:-$d}")' \
    --bind 'ctrl-/:change-preview-window(down,70%,border-horizontal|hidden|)' \
    --prompt 'ghq> ')"
  if [ -n "${dir}" ]; then
    builtin cd -- "$(ghq root)/${dir}" && pwd
  fi
}

# Launch yazi and follow its final working directory.
y() {
  if ! command -v yazi >/dev/null 2>&1; then
    echo "yazi is not installed." >&2
    return 127
  fi

  local tmp
  local cwd
  local result

  tmp="$(mktemp "${TMPDIR:-/tmp}/yazi-cwd.XXXXXX")" || return
  command yazi "$@" --cwd-file="$tmp"
  result=$?
  cwd="$(cat -- "$tmp" 2>/dev/null || true)"
  command rm -f -- "$tmp"

  if [ -n "${cwd}" ] && [ "${cwd}" != "${PWD}" ] && [ -d "${cwd}" ]; then
    builtin cd -- "${cwd}" || {
      echo "failed to cd to yazi cwd: ${cwd}" >&2
      return 1
    }
  fi

  return "${result}"
}

if [ -n "${WSL_DISTRO_NAME:-}" ]; then
  # For WSL, set Windows browser as default.
  export BROWSER='/mnt/c/Windows/System32/rundll32.exe url.dll,FileProtocolHandler'

  # This allows `gh browse` or `open .` to open the Windows browser.
  open() {
    local path="${1:-.}"
    explorer.exe "$(wslpath -w "${path}")"
  }
fi
