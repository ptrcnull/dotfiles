set -ex

export TERM="xterm-256color"
export OTHER=$HOME/.zsh
export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="powerlevel9k/powerlevel9k"
source $OTHER/powerlevel_settings.sh
source $ZSH/oh-my-zsh.sh

COMPLETION_WAITING_DOTS="true"

plugins=(git docker)

export EDITOR=nano
export JAVA_HOME=

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

if [ -e "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
fi
