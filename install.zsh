#!/bin/zsh

if [ "$ZSH_EVAL_CONTEXT" = "toplevel" ]; then
	echo "[!] this script is meant to be sourced"
	echo "source install.zsh" > /dev/stdin
	exit 1
fi

plugins_dir="$HOME/.local/share/zsh-plugins"
plugins_alpine="
  starship
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-completions
"
plugins_git="
  https://github.com/zsh-users/zsh-syntax-highlighting
  https://github.com/zsh-users/zsh-autosuggestions
"

for cmd in curl git sed install find; do
  if ! command -v $cmd >/dev/null; then
    echo "[!] $cmd not found"
    exit 1
  fi
done

set -e

# migrate legacy
mkdir -p "$HOME"/.config/zsh
touch "$HOME"/.config/zsh/local.zsh
if [ -d "$HOME"/.zsh-custom ]; then
	for file in "$HOME"/.zsh-custom/*; do
		echo "# $file" >> "$HOME"/.config/zsh/local.zsh
		cat "$file" >> "$HOME"/.config/zsh/local.zsh
		echo "" >> "$HOME"/.config/zsh/local.zsh
		rm "$file"
	done
	rmdir "$HOME"/.zsh-custom
fi

install() {
  command install -dv "$(dirname "$2")" || true
  # screw you coreutils install and your ugly messages
  command install -v $@ | grep -v removed
}

echo "[*] installing config files"
install -m644 .zshrc "$HOME"/.zshrc
find config -type f | while read file; do
	install $file $(echo $file | sed "s|config|$HOME/.config|")
done

echo "[*] installing executables"
find bin -type f | while read file; do
	install $file $(echo $file | sed "s|bin|$HOME/.local/bin|")
done

if [ -f "$HOME"/.zshenv ] && [ ! -L "$HOME"/.zshenv ]; then
	mv "$HOME"/.zshenv "$HOME"/.zshenv.bak
	echo "[!] moved ~/.zshenv to ~/.zshenv.bak"
fi

ln -svf "$HOME"/.config/environment "$HOME"/.zshenv

if ! { [ -f "$HOME"/.ssh/authorized_keys ] && grep -q patrycja "$HOME"/.ssh/authorized_keys }; then
  echo "[*] installing SSH keys"
  mkdir -p "$HOME"/.ssh
  curl -L https://ptrc.gay/keys >> "$HOME"/.ssh/authorized_keys
fi

os_id="$( . /etc/os-release 2>/dev/null && echo "$ID" || echo "unknown" )"

# if on alpine, install stuff system-wide
if [ "$os_id" = "alpine" ]; then
  elevate=

  if [ "$(id -u)" != 0 ]; then
    if command -v doas >/dev/null; then
      elevate=doas
    elif command -v sudo >/dev/null; then
      elevate=sudo
    else
      echo "[!] cannot install zsh plugins system-wide"
      elevate=:
    fi
  fi

  for plugin in $=plugins_alpine; do
    if ! grep -q "P:$plugin" /lib/apk/db/installed; then
      echo "[*] installing $plugin system-wide"
      $elevate apk add "$plugin"
    else
      echo "[+] $plugin installed already"
    fi
  done
else
  for plugin in $=plugins_git; do
    name="${plugin/*\//}"

    if [ ! -d "$plugins_dir/$name" ]; then
      echo "[*] installing $name locally"
      git clone --depth=1 "$plugin" "$plugins_dir/$name"
    else
      echo "[+] $name installed already"
    fi
  done
fi

if [ -d "$HOME"/.oh-my-zsh ]; then
  echo "[*] cleaning up oh-my-zsh"
  rm -rf "$HOME"/.oh-my-zsh
fi

if [ -d "$HOME"/.zsh ]; then
  echo "[*] cleaning up .zsh"
  rm -rf "$HOME"/.zsh
fi

unfunction install

exec zsh
