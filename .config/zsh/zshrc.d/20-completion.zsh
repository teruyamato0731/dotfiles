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
