# region: XDG Configuration
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CURRENT_DESKTOP="${XDG_CURRENT_DESKTOP:-sway}"
export XDG_SESSION_DESKTOP=$XDG_CURRENT_DESKTOP
export XDG_SESSION_TYPE=wayland

typeset -TUx XDG_DATA_DIRS xdg_data_dirs :

if [[ $#xdg_data_dirs -eq 0 ]]; then
  xdg_data_dirs=(/usr/local/share /usr/share)
fi

# Append Flatpak exports to XDG_DATA_DIRS
xdg_data_dirs=(
  "$HOME/.local/share/flatpak/exports/share"
  "/var/lib/flatpak/exports/share"
  $xdg_data_dirs
)
# endregion

# region: Aliases & Utils
alias ls='ls --color=auto'
alias desktop-file-install="desktop-file-install --dir='$XDG_DATA_HOME/applications'"

# Snap support
[[ -d "/var/lib/snapd/snap/bin" ]] && export PATH="$PATH:/var/lib/snapd/snap/bin"

# Wayland + Nvidia tweaks
if [[ -r /proc/cmdline ]] && grep -q 'nvidia-drm.modeset=1' /proc/cmdline; then
  export GBM_BACKEND=nvidia-drm
  export __GLX_VENDOR_LIBRARY_NAME=nvidia
  export __NV_PRIME_RENDER_OFFLOAD=1
fi
# endregion

# region: Development Tools

# JetBrains Toolbox
if [[ -d "$XDG_DATA_HOME/JetBrains/Toolbox" ]]; then
  export PATH="$PATH:$XDG_DATA_HOME/JetBrains/Toolbox/bin:$XDG_DATA_HOME/JetBrains/Toolbox/scripts"
fi

# Android Studio
export ANDROID_HOME="$HOME/Android/Sdk"

# Browser specific vars
export CHROME_EXECUTABLE="/opt/google/chrome/chrome"
export MOZ_ENABLE_WAYLAND=1

# SSH Keychain / Agent
# Handles either Gnome Keyring or `keychain` package
if [[ -z "$SSH_AUTH_SOCK" || ! -S "$SSH_AUTH_SOCK" ]]; then
  if command -v gnome-keyring-daemon > /dev/null; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
  elif command -v keychain > /dev/null; then
    # Load all public keys from ~/.ssh
    __ssh_keys=(${$(find ~/.ssh -type f -name '*.pub')%.pub})
    if (( ${#__ssh_keys} > 0 )); then
      eval $(keychain --eval --agents ssh --quiet $__ssh_keys)
    fi
    unset __ssh_keys
  fi
fi
# endregion
