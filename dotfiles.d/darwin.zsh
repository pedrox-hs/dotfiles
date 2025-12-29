# region: macOS Applications Path

# JetBrains Toolbox
[[ -d "/Applications/JetBrains Toolbox.app/Contents/MacOS" ]] && \
  export PATH="$PATH:/Applications/JetBrains Toolbox.app/Contents/MacOS"

# IntelliJ IDEA
[[ -d "$HOME/Applications/IntelliJ IDEA.app/Contents/MacOS" ]] && \
  export PATH="$PATH:$HOME/Applications/IntelliJ IDEA.app/Contents/MacOS"

# Android Studio
[[ -d "$HOME/Applications/Android Studio.app/Contents/MacOS" ]] && \
  export PATH="$PATH:$HOME/Applications/Android Studio.app/Contents/MacOS"
  
export ANDROID_HOME="$HOME/Library/Android/sdk"

# Docker
[[ -d "$HOME/.docker/bin" ]] && export PATH="$PATH:$HOME/.docker/bin"

# endregion

# region: System Tweaks

# Load SSH keys into Apple Keychain
ssh-add --apple-load-keychain 2> /dev/null

# endregion
