HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt INTERACTIVE_COMMENTS

autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"

if [[ -d "$HOME/.local/bin" ]] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  PATH="$HOME/.local/bin:$PATH"
fi

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

if [[ $- == *i* ]] && command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

if [[ -f "${HOME}/dotfiles/.config/shell/functions.sh" ]]; then
  source "${HOME}/dotfiles/.config/shell/functions.sh"
fi
