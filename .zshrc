# https://github.com/ptrcnull/dotfiles

export TERM="xterm-256color"
autoload -Uz compinit
compinit

for f in "$HOME"/.zsh/*; do
  if [ -f $f ]; then
    source $f
  fi
done

if [ -d "$HOME"/.zsh-custom ]; then
  for f in "$HOME"/.zsh-custom/*; do
    if [ -f $f ]; then
      source $f
    fi
  done
fi

if [ -d /usr/share/zsh/plugins ]; then
	plugins="/usr/share/zsh/plugins"
else
	plugins="$HOME/.local/share/zsh-plugins"
fi

source "$plugins/powerlevel10k/powerlevel10k.zsh-theme"
source "$plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
