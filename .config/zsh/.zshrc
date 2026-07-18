HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
mkdir -p "${HISTFILE:h}"

setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt INTERACTIVE_COMMENTS

zsh_completion_dir="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/site-functions"
if [[ -d "$zsh_completion_dir" ]]; then
  typeset -U fpath
  fpath=("$zsh_completion_dir" "${fpath[@]}")
fi
unset zsh_completion_dir

mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"

bindkey -e
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

if [[ -d "$HOME/.local/bin" ]] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  PATH="$HOME/.local/bin:$PATH"
fi

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

if [[ -f "${HOME}/dotfiles/.config/shell/functions.sh" ]]; then
  source "${HOME}/dotfiles/.config/shell/functions.sh"
fi

# ---------------------------------------------------------------------------
# Key bindings
# ---------------------------------------------------------------------------

# Ctrl+O: ghqリポジトリへ移動
_zle_gcd() {
  zle -I
  gcd
  local result=$?
  zle reset-prompt
  return "$result"
}

zle -N gcd-widget _zle_gcd
bindkey '^O' gcd-widget

# Ctrl+]: git wswを実行
_zle_git_wsw() {
  zle -I
  git wsw
  local result=$?
  zle reset-prompt
  return "$result"
}

zle -N git-wsw-widget _zle_git_wsw
bindkey '^]' git-wsw-widget

# Ctrl+X Ctrl+Y: yaziを開き、終了後にcwdを反映
_zle_yazi() {
  zle -I
  y
  local result=$?
  zle reset-prompt
  return "$result"
}

zle -N yazi-widget _zle_yazi
bindkey '^X^Y' yazi-widget

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Autosuggestions
_zsh_autosuggestions="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
if [[ -r "$_zsh_autosuggestions" ]]; then
  source "$_zsh_autosuggestions"
fi
unset _zsh_autosuggestions

# Must be loaded last
_zsh_syntax_highlighting="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
if [[ -r "$_zsh_syntax_highlighting" ]]; then
  source "$_zsh_syntax_highlighting"
fi
unset _zsh_syntax_highlighting
