export ZSH=$HOME/.oh-my-zsh
#ZSH_THEME="agnoster"
ZSH_THEME="powerlevel9k/powerlevel9k"
source $ZSH/oh-my-zsh.sh

COMPLETION_WAITING_DOTS="true"

plugins=(git)

export EDITOR=nano
export JAVA_HOME=
export OTHER=$HOME/.zsh

source $OTHER/powerlevel_settings.sh
source $OTHER/aliases.sh
source $OTHER/path_custom.sh
source $OTHER/transfer.sh
