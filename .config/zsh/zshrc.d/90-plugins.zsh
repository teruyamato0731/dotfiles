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
