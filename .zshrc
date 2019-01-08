export OTHER=$HOME/.zsh
export ZSH=$HOME/.oh-my-zsh
#ZSH_THEME="agnoster"
ZSH_THEME="powerlevel9k/powerlevel9k"
source $OTHER/powerlevel_settings.sh
source $ZSH/oh-my-zsh.sh

COMPLETION_WAITING_DOTS="true"

plugins=(git)

export EDITOR=nano
export JAVA_HOME=

source $OTHER/aliases.sh
source $OTHER/path_custom.sh
source $OTHER/transfer.sh
source $OTHER/node_packages.sh
source $OTHER/node_deps.sh

if [ "$(uname)" = "Darwin" ]; then
  source $OTHER/mac_gpg_fix.sh
  source $OTHER/mac_android_sdk_path.sh
fi

test -e "${HOME}/flutter/bin" && source $OTHER/flutter_path.sh
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
test -e "${HOME}/.cargo/env" && source "${HOME}/.cargo/env"

if which sshfs > /dev/null; then
  source $OTHER/mountssh.sh
fi

source $OTHER/blockip.sh
source $OTHER/cdtemp.sh
source $OTHER/stego-toolkit.sh

test -e "${OTHER}/github-token.sh" && source $OTHER/github-token.sh

source $OTHER/renew-cert.sh
