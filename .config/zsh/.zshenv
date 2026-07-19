# Keep this file as the single source of truth for zshenv configuration.
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# Ubuntu's /etc/zsh/zshrc runs compinit unless this is set in $ZDOTDIR/.zshenv.
skip_global_compinit=1
