if [ "$(uname)" = "Darwin" ]; then
  export GPG_TTY=$(tty)
fi
