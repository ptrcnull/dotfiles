__ptrc_set_title() {
  title="$1"
  [ -n "$SSH_TTY" ] && title="$USER@$HOST: $title"
  printf "\e]0;$title\a"
}

precmd () {
  __ptrc_set_title "$PWD"
}

preexec () {
  __ptrc_set_title "$1"
}
