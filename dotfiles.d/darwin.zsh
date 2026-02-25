# region: macOS Applications Path

# JetBrains Toolbox
if [[ -d "/Applications/JetBrains Toolbox.app/Contents/MacOS" ]]; then
  export PATH="$PATH:/Applications/JetBrains Toolbox.app/Contents/MacOS:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
fi

export ANDROID_HOME="$HOME/Library/Android/sdk"

# Docker
[[ -d "$HOME/.docker/bin" ]] && export PATH="$PATH:$HOME/.docker/bin"

# endregion

# region: System Tweaks

# Set Homebrew prefix based on architecture
if [[ "$(/usr/bin/uname -m)" == "arm64" ]]
then
    # On ARM macOS, this script installs to /opt/homebrew only
    HOMEBREW_PREFIX="/opt/homebrew"
else
    # On Intel macOS, this script installs to /usr/local only
    HOMEBREW_PREFIX="/usr/local"
fi
eval "$(${HOMEBREW_PREFIX}/bin/brew shellenv)"

# Load SSH keys into Apple Keychain
ssh-add --apple-load-keychain 2> /dev/null

# Timeout command polyfill
 if ! command -v timeout &> /dev/null; then
   if command -v gtimeout &> /dev/null; then
     alias timeout='gtimeout'
   else
     timeout() {
       local duration="$1"
       shift
       perl -e "alarm shift; exec @ARGV" "$duration" "$@"
     }
   fi
 fi

# endregion
