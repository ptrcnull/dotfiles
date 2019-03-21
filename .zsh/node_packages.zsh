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
