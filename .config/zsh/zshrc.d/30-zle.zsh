# Base ZLE setup must run before fzf's key bindings are initialized.
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
