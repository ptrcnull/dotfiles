precmd () {
  printf "\e]0;$PWD\a"
}

preexec () {
  printf "\e]0;$1\a"
}
