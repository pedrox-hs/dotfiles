POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# Only load P10k if not in a raw Linux TTY (console)
if [[ "$TERM" != "linux" ]]; then

  # Enable Powerlevel10k instant prompt
  __instant_prompt_cache="${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  if [[ -r "$__instant_prompt_cache" ]]; then
    source "$__instant_prompt_cache"
  fi
  unset __instant_prompt_cache

  # Load Theme
  if [[ -d "$HOME/.powerlevel10k" ]]; then
    source "$HOME/.powerlevel10k/powerlevel10k.zsh-theme"
    
    # Load user customization
    [[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
  fi

else
  # Fallback prompt for TTY
  PROMPT='%n@%m %F{blue}%~%f %# '
fi
