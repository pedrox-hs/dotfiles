# region: ZSH options
typeset -U path PATH # Ensure no duplicates in PATH

setopt APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt INTERACTIVE_COMMENTS
setopt SHARE_HISTORY

export CLICOLOR=1
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=50000
export HISTCONTROL=ignoreboth
export HIST_MAX_LINES_BY_ENTRY=10

# prevents big commands in zsh_history
zshaddhistory() {
  local line_count=${#1//[^$'\n']/}

  if (( line_count > HIST_MAX_LINES_BY_ENTRY )); then
    return 1
  fi

  return 0
}
# endregion

# region: General Envs and Aliases
export EDITOR=$(command -v nvim >/dev/null && echo "nvim" || echo "vim")
export PATH="$PATH:$HOME/.local/bin:$DOTFILES_ROOT/bin:$HOME/Devel/bin"

alias ll='ls -lh'
alias grep='grep --color=auto'
# endregion

# Load configuration files
source_if_exists \
  "$DOTFILES_DIR/keys.zsh" \
  "$DOTFILES_DIR/fastfetch.zsh"

if command -v starship >/dev/null; then
  source_if_exists "$DOTFILES_DIR/starship.zsh"
else
  source_if_exists "$DOTFILES_DIR/p10k_init.zsh"
fi

source_if_exists \
  "$DOTFILES_DIR/asdf.zsh" \
  "$DOTFILES_DIR/miniforge.zsh" \
  "$DOTFILES_DIR/kernel_profile.zsh"

# External plugins
# zsh-autosuggestions
source_if_exists "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

# FZF
[[ -x "$(command -v fzf)" ]] && source <(fzf --zsh)

# Rust
source_if_exists "$HOME/.cargo/env"

# Android SDK
export ANDROID_AVD_HOME="${XDG_CONFIG_HOME:-$HOME}/.android/avd"
if [[ -d "$ANDROID_HOME" ]]; then
  export ANDROID_SDK_ROOT="$ANDROID_HOME"
  
  # Get latest build-tools version
  __android_build_tools=$(ls -d $ANDROID_HOME/build-tools/*(nOn[1]) 2>/dev/null)
  
  export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$__android_build_tools"
  unset __android_build_tools
fi

# Flutter / FVM
[[ -n "$(command -v asdf)"   ]] && export FLUTTER_ROOT="$(asdf where flutter 2>/dev/null)"
[[ -d "$HOME/.pub-cache/bin" ]] && export PATH="$PATH:$HOME/.pub-cache/bin"

# GCloud CLI
[[ -d "$HOME/Devel/Tools/google-cloud-sdk" ]] && export PATH="$PATH:$HOME/Devel/Tools/google-cloud-sdk/bin"

# SDKMAN!
export SDKMAN_DIR="$HOME/.sdkman"
source_if_exists "$HOME/.sdkman/bin/sdkman-init.sh"

# Ensure SDKMAN! candidates are at the front of PATH
if [ -d "$SDKMAN_DIR/candidates" ]; then
  for candidate in "$SDKMAN_DIR/candidates"/*(/N); do
    [[ -d "$candidate/current/bin" ]] && export PATH="$candidate/current/bin:$PATH"
  done
fi

# Ensure ASDF shims are at the front of PATH
if [ -d "$HOME/.asdf/shims" ]; then
  export PATH="$HOME/.asdf/shims:$PATH"
fi


# autocomplete
zstyle ':completion:*' menu select
autoload -Uz compinit
compinit


# Start Window Manager (Linux TTY1 only)
if [[ -z "$WAYLAND_DISPLAY" && -z "$DISPLAY" && "$XDG_VTNR" -eq 1 ]]; then
  if [[ -s "$HOME/.wm-init" ]]; then
    source "$HOME/.wm-init"; exit
  elif command -v sway >/dev/null; then
    exec sway --unsupported-gpu > /tmp/sway.log 2>&1; exit
  fi
fi
