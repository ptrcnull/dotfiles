#!/usr/bin/env zsh
# env, because some OSes keep zsh in /bin (I'm looking at you, Alpine)

if ! command -v curl >/dev/null; then
  echo "[!] curl not found"
  exit 1
fi

if [ ! -d "${HOME}/.oh-my-zsh" ]; then
  echo "[*] installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
  echo "[+] oh-my-zsh installed already"
fi

echo "[*] copying .zshrc"
cp .zshrc $HOME

echo "[*] copying .p10k.zsh"
cp .p10k.zsh $HOME

OMZ="${HOME}/.oh-my-zsh/custom"

if [ ! -d "${OMZ}/themes/powerlevel10k" ]; then
  echo "[*] installing powerlevel10k"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${OMZ}/themes/powerlevel10k"
else
  echo "[+] powerlevel10k installed already"
fi

if [ ! -d "${OMZ}/plugins/zsh-syntax-highlighting" ]; then
  echo "[*] installing zsh-syntax-highlighting"
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${OMZ}/plugins/zsh-syntax-highlighting"
else
  echo "[+] zsh-syntax-highlighting installed already"
fi

if [ ! -d "${OMZ}/plugins/zsh-autosuggestions" ]; then
  echo "[*] installing zsh-autosuggestions"
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "${OMZ}/plugins/zsh-autosuggestions"
else
  echo "[+] zsh-autosuggestions installed already"
fi

if [ -d "${HOME}/.zsh" ]; then
  echo "[*] removing existing .zsh"
  rm -r $HOME/.zsh
fi

echo "[*] copying .zsh"
cp -r .zsh $HOME

if [ ! -d "$HOME/.bin" ]; then
  echo "[*] creating $HOME/.bin"
  mkdir -p $HOME/.bin
fi

if ! which micro 2>/dev/null; then
  echo "[*] installing micro"
  pushd "$HOME/.bin"
  curl https://getmic.ro | bash
  popd
else
  echo "[+] micro already installed"
fi

zsh
