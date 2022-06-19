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

if ! command -v curl >/dev/null; then
  echo "[!] curl not found"
  exit 1
fi

if ! command -v git >/dev/null; then
  echo "[!] git not found"
  exit 1
fi

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

echo "[*] installing config files"
install -D .zshrc -t "$HOME"
install -D environment -t "$HOME"/.config
install -D starship.toml -t "$HOME"/.config
install -D foot.ini -t "$HOME"/.config/foot
install -D i3status.toml "$HOME"/.config/i3status-rust/config.toml

if ! { [ -f "$HOME"/.ssh/authorized_keys ] && grep -q patrycja "$HOME"/.ssh/authorized_keys }; then
  echo "[*] installing SSH keys"
  mkdir -p "$HOME"/.ssh
  curl -L https://keys.ptrc.pl >> "$HOME"/.ssh/authorized_keys
fi

# if on alpine 3.16, install stuff system-wide
. /etc/os-release
if [ "$ID" = "alpine" ] && [[ "$VERSION_ID" == "3.16"* ]]; then
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

exec zsh
