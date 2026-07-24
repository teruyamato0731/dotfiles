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
