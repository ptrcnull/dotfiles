# https://github.com/ptrcnull/dotfiles

autoload -Uz compinit
compinit

load() {
	[ -f "$1" ] && . "$1"
}

load "$HOME/.config/environment"

if [ -d /usr/share/zsh/plugins ] && [ -d /usr/share/zsh/plugins/zsh-autosuggestions ]; then
	plugins="/usr/share/zsh/plugins"
else
	plugins="$HOME/.local/share/zsh-plugins"
fi

source "$plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

load "$HOME/.config/zsh/local.zsh"
load "$HOME/.cargo/env"

unfunction load

__ptrc_prompt() {
	local c_green=$'%{\x1b[32m%}'
	local c_blue=$'%{\x1b[34m%}'
	local c_reset=$'%{\x1b[0m%}'

	echo "${c_blue}%~ ${c_green}>$c_reset "
}

iscmd() {
	command -v "$1" > /dev/null
}

if iscmd starship; then
	source <(starship init zsh --print-full-init)
else
	setopt promptsubst
	export PS1='$(__ptrc_prompt)'
fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ip='ip --color=auto'
alias diff='diff --color=auto'
alias ncdu='ncdu --color off'
alias lldb='TERM=xterm-256color lldb'
alias apatch='CUSTOM_PROMPT_TAG=apatch apatch'
alias gdb='gdb -q'

alias lls='ls'
alias sl='ls'
alias ll='ls -lah'
alias gitresethard='git reset --hard HEAD && git clean -df'
alias dps='docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"'
if iscmd hx; then
	alias nano='hx'
elif iscmd micro; then
	alias nano='micro'
fi
alias cal='cal -m'
alias cdtemp='cd $(mktemp -d)'
alias wrl='while { read line }'
alias falsedo='false; while { [ $? != 0 ] }'
alias rga='rg -uuui'

alias c='docker-compose'
if ! iscmd docker-compose; then
	alias c='docker compose'
fi

if ! iscmd docker && iscmd podman; then
	alias docker='podman'
	alias c='podman-compose'
fi

wget() {
	local dl='curl -LO'
	if iscmd aria2c; then
		dl='aria2c'
	fi

	if [ $# = 1 ]; then
		$dl "$1"
	else
		command wget "$@"
	fi
}

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

cpf() {
	wl-copy --type text/uri-list "file://$(realpath $1)"
}

if iscmd hx; then
	export EDITOR=hx
elif iscmd micro; then
	export EDITOR=micro
else
	export EDITOR=nano
fi

[ -d "$HOME/flutter/bin" ] && export PATH="$HOME/flutter/bin:$PATH"
[ -d "$HOME/.cargo/bin" ] && export PATH="$HOME/.cargo/bin:$PATH"

if [ -d "$HOME/go" ]; then
  export GOPATH="$HOME/go"
  export PATH="$GOPATH/bin:$PATH"
fi

# TODO remove
if iscmd git; then
  if ! grep -q tree ~/.gitconfig 2>/dev/null; then
    git config --global alias.tree "log --oneline --graph --decorate --all"
  fi
fi

go-static-build () {
	CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o $1 .
}

tpaste() {
	curl -F 'tpaste=<-' https://tpaste.us/
}

squash() {
	mksquashfs "$1" "$1.zst.sfs" -comp zstd -Xcompression-level 15
}

nb() {
  git checkout -b $1 master
}

patch2log() {
	local url="$(wl-paste -t text/plain)"
	local repo_url=${url%/compare*}
	(
		echo "[\`${url#*compare/}\`]($url)"
		echo
		curl $url.patch \
			| rg -U -e "Subject: .*(\n .*)*" -e "From " \
			| sd "\n " " " \
			| sd "From (.{8}).*\nSubject: \[.*?\] (.*)" '> [`$1`]('$repo_url'/commit/$1) $2  ' \
			| sd "#(\d+)" '[#$1]('$repo_url'/issues/$1)'
	) | wl-copy
}

__ptrc_set_title() {
  title="$1"
  [ -n "$SSH_TTY" ] && title="$USER@$HOST: $title"
  printf "\e]0;%s\a" "$title"
}

precmd() {
  __ptrc_set_title "$PWD"
}

preexec() {
  __ptrc_set_title "$1"
}

# Git aliases
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -v'
alias gcn='git commit -v --no-edit --amend && git rebase HEAD~1 --committer-date-is-author-date'
alias gcan='git commit -v -a --no-edit --amend && git rebase HEAD~1 --committer-date-is-author-date'
alias gcm='git checkout master'
alias gcl='git clone --recurse-submodules'
alias gclean='git clean -id'
alias gpristine='git reset --hard && git clean -dffx'
alias gp='git push'
alias gpf='git push --force'
alias gpa='git push -u aports $(git symbolic-ref --short HEAD)'
alias grm='EDITOR=true git rebase --autosquash -i origin/master'
alias gr='git rebase'
alias grbc='git rebase --continue'

alias history='fc -l 0'

commit-aports() {
	git status --porcelain | cut -c4- | cut -d/ -f1-2 | while read line; do
		git add $line
		if [ "$1" != "" ]; then
			git commit -m "$line: $1"
		else
			git commit
		fi
	done
}

## History file configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000000
SAVEHIST=10000000

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
  zle-line-init() {
    echoti smkx
  }
  zle-line-finish() {
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

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line

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

autoload -Uz add-zsh-hook

# send current directory to the terminal
osc7() {
    setopt localoptions extendedglob
    input=( ${(s::)PWD} )
    uri=${(j::)input/(#b)([^A-Za-z0-9_.\!~*\'\(\)-\/])/%${(l:2::0:)$(([##16]#match))}} # ' micro bad
    print -n "\e]7;file://${HOSTNAME}${uri}\e\\"
}
add-zsh-hook -Uz chpwd osc7

# disable xoff/xon
stty -ixoff -ixon

if [ "$SSH_TTY" ]; then
	if [ -d "/run/user/$(id -u)" ]; then
		export XDG_RUNTIME_DIR="/run/user/$(id -u)"
	else
		if [ -d "/tmp/run-$(id -u)" ]; then
			export XDG_RUNTIME_DIR="/tmp/run-$(id -u)"
		fi
	fi

	if pidof swaync >/dev/null; then
		tr '\0' '\n' < "/proc/$(pidof swaync)/environ" \
			| rg -e "DISPLAY" -e "SWAYSOCK" \
			| while read line; do export $line; done
	fi
	if [ -S "$XDG_RUNTIME_DIR/bus" ]; then
		export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
	fi
fi
