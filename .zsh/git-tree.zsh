if which git > /dev/null; then
  if ! grep tree ~/.gitconfig 2>&1 >/dev/null; then
    git config --global alias.tree "log --oneline --graph --decorate --all"
  fi
fi
