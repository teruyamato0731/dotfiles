# shellcheck shell=bash

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  # $1 が "." の場合は引数として渡さない
  if [ "$1" = "." ]; then
    fd --hidden --exclude '.git' .
  else
    fd --hidden --exclude '.git' . "$1"
  fi
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  if [ "$1" = "." ]; then
    fd --type d --hidden --exclude '.git' .
  else
    fd --type d --hidden --exclude '.git' . "$1"
  fi
}

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments ($@) to fzf.
_fzf_comprun() {
  local command="$1"
  shift

  case "$command" in
    (export|unset)
      fzf --preview "eval 'echo \$'{}" "$@"
      ;;
    (ssh)
      fzf --preview 'ssh -G -- {} 2>/dev/null | bat --color=always --style=plain --language=ssh_config' \
          --preview-label=' effective ssh config ' \
          "$@"
      ;;
    (*)
      eval "fzf ${FZF_CTRL_T_OPTS}" '"$@"'
      ;;
  esac
}
