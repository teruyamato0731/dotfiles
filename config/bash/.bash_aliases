alias ll='ls -alF'
alias l='ls -CF'

# rmをゴミ箱コマンドに
if type trash-put &> /dev/null; then
  alias rm='trash-put'
fi
