#!/usr/bin/env zsh
# env, because some OSes keep zsh in /bin (I'm looking at you, Alpine)

if ! command -v curl >/dev/null; then
  echo "[!] curl not found"
  exit 1
fi

if ! command -v git >/dev/null; then
  echo "[!] git not found"
  exit 1
fi

echo "[*] copying .zshrc"
cp .zshrc "$HOME"

echo "[*] copying .p10k.zsh"
cp .p10k.zsh "$HOME"

echo "[*] copying environment"
mkdir -p "$HOME"/.config
cp environment "$HOME"/.config/environment

plugins="$HOME/.local/share/zsh-plugins"

# if on alpine edge, install stuff system-wide
. /etc/os-release
if [ "$ID" = "alpine" ] && [[ "$VERSION_ID" == *"_alpha"* ]]; then
  [ "$(id -u)" = "0" ] || cmd="doas"
  echo "[*] installing stuff"
  $cmd apk add zsh-theme-powerlevel10k zsh-syntax-highlighting zsh-autosuggestions zsh-completions
else
  if [ ! -d "$plugins"/powerlevel10k ]; then
    echo "[*] installing powerlevel10k"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$plugins"/powerlevel10k
  else
    echo "[+] powerlevel10k installed already"
  fi

  if [ ! -d "$plugins"/zsh-syntax-highlighting ]; then
    echo "[*] installing zsh-syntax-highlighting"
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugins"/zsh-syntax-highlighting
  else
    echo "[+] zsh-syntax-highlighting installed already"
  fi

  if [ ! -d "$plugins"/zsh-autosuggestions ]; then
    echo "[*] installing zsh-autosuggestions"
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$plugins"/zsh-autosuggestions
  else
    echo "[+] zsh-autosuggestions installed already"
  fi
fi

if [ -d "$HOME"/.oh-my-zsh ]; then
  echo "[*] cleaning up oh-my-zsh"
  rm -r "$HOME"/.oh-my-zsh
fi

if [ -d "$HOME"/.zsh ]; then
  echo "[*] cleaning up .zsh"
  rm -r "$HOME"/.zsh
fi

exec zsh
