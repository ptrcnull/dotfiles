# https://github.com/ptrcnull/dotfiles

autoload -Uz compinit
compinit

function load() {
	[ -f "$1" ] && . "$1"
}

load "$HOME/.config/environment"

if [ -d /usr/share/zsh/plugins ]; then
	plugins="/usr/share/zsh/plugins"
else
	plugins="$HOME/.local/share/zsh-plugins"
fi

source "$plugins/powerlevel10k/powerlevel10k.zsh-theme"
source "$plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# legacy stuff
if [ -d "$HOME"/.zsh-custom ]; then
	for f in "$HOME"/.zsh-custom/*; do
		load "$f"
	done
fi

load "$HOME/.config/zsh"
load "$HOME/.p10k.zsh"
load "$HOME/.cargo/env"

unfunction load

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ip='ip --color=auto'
alias diff='diff --color=auto'
alias ncdu='ncdu --color off'

alias lls='ls'
alias sl='ls'
alias ll='ls -lah'
alias m4a='youtube-dl --o "%(title)s.%(ext)s" --format m4a --add-metadata'
alias gitresethard='git reset --hard HEAD && git clean -df'
alias dps='docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"'
alias c='docker-compose'
alias nano='micro'
alias cal='cal -m'
alias cdtemp='cd $(mktemp -d)'
alias wget='curl -LO'
if command -v aria2c >/dev/null; then
	alias wget='aria2c'
fi

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

function cpf() {
	wl-copy --type text/uri-list "file://$(realpath $1)"
}

if command -v micro >/dev/null; then
	export EDITOR=micro
else
	export EDITOR=nano
fi

[ -d "$HOME/flutter/bin" ] && export PATH="$HOME/flutter/bin:$PATH"

if [ -d "$HOME/go" ]; then
  export GOPATH="$HOME/go"
  export PATH="$GOPATH/bin:$PATH"
fi

# TODO remove
if command -v git >/dev/null; then
  if ! grep -q tree ~/.gitconfig 2>/dev/null; then
    git config --global alias.tree "log --oneline --graph --decorate --all"
  fi
fi

function go-static-build () {
	CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o $1 .
}

function tpaste() {
	curl -F 'tpaste=<-' https://tpaste.us/
}

function squash() {
	mksquashfs "$1" "$1.zst.sfs" -comp zstd -Xcompression-level 22
}

function falsedo() (
	false; while [[ $? != 0 ]]; do $@; done
)

function nb() {
  git checkout -b $1 master
}

function __ptrc_set_title() {
  title="$1"
  [ -n "$SSH_TTY" ] && title="$USER@$HOST: $title"
  printf "\e]0;%s\a" "$title"
}

function precmd () {
  __ptrc_set_title "$PWD"
}

function preexec () {
  __ptrc_set_title "$1"
}

# Git aliases
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -v'
alias gcn='git commit -v --no-edit --amend'
alias gcan='git commit -v -a --no-edit --amend'
alias gcn!='git commit -v --no-edit --amend'
alias gcan!='git commit -v -a --no-edit --amend'
alias gcm='git checkout master'
alias gcl='git clone --recurse-submodules'
alias gclean='git clean -id'
alias gpristine='git reset --hard && git clean -dffx'
alias gp='git push'
alias gpf='git push --force'
alias gpa='git push -u aports $(git symbolic-ref --short HEAD)'
alias grm='git rebase origin/master'

# History wrapper
function omz_history {
  local clear list
  zparseopts -E c=clear l=list

  if [[ -n "$clear" ]]; then
    # if -c provided, clobber the history file
    echo -n >| "$HISTFILE"
    fc -p "$HISTFILE"
    echo >&2 History file deleted.
  elif [[ -n "$list" ]]; then
    # if -l provided, run as if calling `fc' directly
    builtin fc "$@"
  else
    # unless a number is provided, show all history events (starting from 1)
    [[ ${@[-1]-} = *[0-9]* ]] && builtin fc -l "$@" || builtin fc -l "$@" 1
  fi
}

# Timestamp format
case ${HIST_STAMPS-} in
  "mm/dd/yyyy") alias history='omz_history -f' ;;
  "dd.mm.yyyy") alias history='omz_history -E' ;;
  "yyyy-mm-dd") alias history='omz_history -i' ;;
  "") alias history='omz_history' ;;
  *) alias history="omz_history -t '$HIST_STAMPS'" ;;
esac

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
[ "$HISTSIZE" -lt 50000000 ] && HISTSIZE=50000000
[ "$SAVEHIST" -lt 10000000 ] && SAVEHIST=10000000

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

# https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/key-bindings.zsh

# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

# Use emacs key bindings
bindkey -e

# Start typing + [Up-Arrow] - fuzzy find history forward
if [[ -n "${terminfo[kcuu1]}" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search

  bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
# Start typing + [Down-Arrow] - fuzzy find history backward
if [[ -n "${terminfo[kcud1]}" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search

  bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# [Home] - Go to beginning of line
if [[ -n "${terminfo[khome]}" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line
fi
# [End] - Go to end of line
if [[ -n "${terminfo[kend]}" ]]; then
  bindkey "${terminfo[kend]}"  end-of-line
fi

# [Shift-Tab] - move through the completion menu backwards
if [[ -n "${terminfo[kcbt]}" ]]; then
  bindkey "${terminfo[kcbt]}" reverse-menu-complete
fi

# [Delete] - delete forward
if [[ -n "${terminfo[kdch1]}" ]]; then
  bindkey "${terminfo[kdch1]}" delete-char
else
  bindkey "^[[3~" delete-char
  bindkey "^[3;5~" delete-char
fi

# [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5C' forward-word
# [Ctrl-LeftArrow] - move backward one word
bindkey '^[[1;5D' backward-word

if [[ -d "$HOME/Library/Android/sdk" ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export PATH=$ANDROID_HOME/tools:$PATH
  export PATH=$ANDROID_HOME/emulator:$PATH
fi
if [ "$(uname)" = "Darwin" ]; then
  export GPG_TTY=$(tty)
fi

if which node > /dev/null; then
  export NPM_PACKAGES="$HOME/.npm-packages"
  export NODE_PATH="$NPM_PACKAGES/lib/node_modules${NODE_PATH:+:$NODE_PATH}"
  export PATH="$NPM_PACKAGES/bin:$PATH"
  # Unset manpath so we can inherit from /etc/manpath via the `manpath`
  # command
  # (fix for Alpine Linux which doesn't have `manpath`)
  if which manpath > /dev/null; then
    unset MANPATH  # delete if you already modified MANPATH elsewhere in your config
    export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
  fi
fi
# enter directory without "cd "
setopt autocd

# configure completion
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USERNAME -o pid,user,comm -w -w"
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$HOME/.cache/zsh"

# set word characters
WORDCHARS=''

# send current directory to the terminal
function osc7 {
    setopt localoptions extendedglob
    input=( ${(s::)PWD} )
    uri=${(j::)input/(#b)([^A-Za-z0-9_.\!~*\'\(\)-\/])/%${(l:2::0:)$(([##16]#match))}} # ' micro bad
    print -n "\e]7;file://${HOSTNAME}${uri}\e\\"
}
add-zsh-hook -Uz chpwd osc7
