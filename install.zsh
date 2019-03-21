#!/usr/bin/env zsh
# env, because some OSes keep zsh in /bin (I'm looking at you, Alpine)
cp .zshrc $HOME
cp -r .zsh $HOME
source ~/.zshrc
