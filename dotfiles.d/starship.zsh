# reference: https://github.com/starship/starship/discussions/5950#discussioncomment-14060198

# Exit early if Starship is not installed
command -v starship >/dev/null || return

# Initialize Starship
eval "$(starship init zsh)"

# Define transient prompt configurations
TRANSIENT_PROMPT="${PROMPT// prompt / prompt --profile transient }"
TRANSIENT_RPROMPT="${PROMPT// prompt / prompt --profile rtransient }"

autoload -Uz add-zsh-hook
autoload -Uz add-zle-hook-widget

# Hook: Setup trap before prompt display
function transient-prompt-precmd {
    SAVED_PROMPT="$(eval "printf '%s' \"${TRANSIENT_PROMPT}\"")"
    SAVED_RPROMPT="$(eval "printf '%s' \"${TRANSIENT_RPROMPT}\"")"

    # Enable Ctrl+C trap only while ZLE is active
    TRAPINT() {
        transient-prompt
        return $(( 128 + $1 ))
    }
}

# Hook: Cleanup trap before command execution
function transient-prompt-preexec {
    # Disable trap to prevent ZLE errors during command execution
    unfunction TRAPINT 2>/dev/null
}

# Widget: Reset prompt state
function transient-prompt {
    PROMPT="$SAVED_PROMPT" RPROMPT="$SAVED_RPROMPT" zle .reset-prompt
}

# Register hooks
add-zle-hook-widget zle-line-finish transient-prompt
add-zsh-hook precmd transient-prompt-precmd
add-zsh-hook preexec transient-prompt-preexec