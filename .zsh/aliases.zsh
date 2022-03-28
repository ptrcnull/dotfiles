alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ip='ip --color=auto'

alias lls='ls'
alias sl='ls'
alias wget='wget -c'
alias zshr='exec zsh'
alias m4a='youtube-dl --o "%(title)s.%(ext)s" --format m4a --add-metadata'
alias gitresethard='git reset --hard HEAD && git clean -df'
alias dps='docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"'
alias c='docker-compose'
alias nano='micro'

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
