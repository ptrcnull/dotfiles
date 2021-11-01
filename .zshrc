export TERM="xterm-256color"
export OTHER=$HOME/.zsh
export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  gitignore
  node
  yarn
  docker
  docker-compose
  python
  golang
  flutter
  nmap
  transfer
  encode64
  urltools
  sudo
  cp
  zsh-syntax-highlighting
  zsh-autosuggestions
)

for f in $OTHER/*; do
  if [ -f $f ]; then
    source $f
  fi
done

if [ -d "$HOME/.zsh-custom" ]; then
  for f in $HOME/.zsh-custom/*; do
    if [ -f $f ]; then
      source $f
    fi
  done
fi

source $ZSH/oh-my-zsh.sh
