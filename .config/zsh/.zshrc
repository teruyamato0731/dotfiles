zshrc_d="${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}/zshrc.d"
for zshrc_file in "$zshrc_d"/*.zsh(N); do
  source "$zshrc_file"
done
unset zshrc_d zshrc_file
