#!/usr/bin/env zsh
# env, because some OSes keep zsh in /bin (I'm looking at you, Alpine)
cp .zshrc $HOME
if [ ! -d "${HOME}/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi
if [ ! -d "${HOME}/.oh-my-zsh/custom/themes/powerlevel9k" ]; then
  git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
fi
if [ -d "${HOME}/.zsh" ]; then
  rm -r $HOME/.zsh
fi
cp -r .zsh $HOME
source $HOME/.zshrc
