if which git > /dev/null; then
  if ! grep -q tree ~/.gitconfig 2>/dev/null; then
    git config --global alias.tree "log --oneline --graph --decorate --all"
  fi
fi
