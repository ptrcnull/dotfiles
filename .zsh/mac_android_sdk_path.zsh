if [[ -d "$HOME/Library/Android/sdk" ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export PATH=$ANDROID_HOME/tools:$PATH
  export PATH=$ANDROID_HOME/emulator:$PATH
fi
