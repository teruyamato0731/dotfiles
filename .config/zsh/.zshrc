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

# Completion settings
zstyle ':completion:*' menu no
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=** r:|=**'

if [[ -z ${LS_COLORS-} ]] && (( $+commands[dircolors] )); then
  eval "$(dircolors -b)"
fi

zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors "${(s.:.)${LS_COLORS-}}"

zstyle ':fzf-tab:*' fzf-flags \
  --height=70% \
  --layout=reverse \
  --border

zstyle ':fzf-tab:complete:(cat|bat):*' fzf-preview \
  'bat -n --color=always "$realpath" 2>/dev/null || eza --tree --level=2 --icons --color=always "$realpath"'

zstyle ':fzf-tab:complete:cd:*' fzf-preview \
  'eza --tree --level=2 --icons --color=always "$realpath"'

zstyle ':fzf-tab:complete:export:*' fzf-preview 'print -r -- "${(P)word}"'
zstyle ':fzf-tab:complete:unset:*' fzf-preview 'print -r -- "${(P)word}"'

zstyle ':fzf-tab:*' switch-group '[' ']'

# Key bindings
bindkey -e
zmodload zsh/terminfo
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n ${terminfo[kcuu1]-} ]] &&
  bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search

[[ -n ${terminfo[kcud1]-} ]] &&
  bindkey "${terminfo[kcud1]}" down-line-or-beginning-search

bindkey '^W' backward-kill-word
bindkey '^[d' kill-word

bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

if [[ -d "$HOME/.local/bin" ]] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  PATH="$HOME/.local/bin:$PATH"
fi

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

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
  y </dev/tty
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
