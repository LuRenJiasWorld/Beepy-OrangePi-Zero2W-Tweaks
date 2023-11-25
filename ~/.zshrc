# 只保留本文相关内容，其他内容请自行添加，如果你有自己的配置文件，则将下面内容添加到你的配置文件中
export PROMPT="%c | # "

export PATH="/home/lurenjiasworld/scripts:$PATH"

alias sudo="sudo -E"

if [[ $(tput cols) -eq 66 ]]; then
  echo "Bringing you into tmux session, please wait..."
  while [[ -f ~/.antigen/.lock ]]; do
    sleep 0.2
  done
  sleep 1
  exec ~/scripts/fbterm.sh
fi
