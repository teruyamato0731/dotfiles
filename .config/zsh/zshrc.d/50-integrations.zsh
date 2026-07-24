if command -v fzf >/dev/null 2>&1; then
  source "${HOME}/dotfiles/.config/shell/fzf.sh"
  source <(fzf --zsh)

  _fzf_tab="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"
  if [[ -r "$_fzf_tab" ]]; then
    source "$_fzf_tab"
  fi
  unset _fzf_tab

  # shim pathをPATHから除外する
  typeset -T PATH path
  path=("${(@)path:#${HOME}/.local/share/mise/shims}")
  rehash
fi

if [[ -f "${HOME}/dotfiles/.config/shell/functions.sh" ]]; then
  source "${HOME}/dotfiles/.config/shell/functions.sh"
fi
