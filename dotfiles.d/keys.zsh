# ------------------------------------------------------------------------------
# Zsh Key Bindings Configuration
# Compatible with Linux (Arch/Manjaro) and macOS
# ------------------------------------------------------------------------------

# 1. Set the main keymap to Emacs (Standard behavior: Ctrl+A, Ctrl+E, etc.)
bindkey -e

# 2. Initialize terminfo database access
# This allows us to ask the system for the correct key codes for the current terminal.
typeset -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# 3. Setup "Smart" History Search
# This allows you to type "git co" and press Up to find only commands starting with that.
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# 4. Bind Standard Keys (using terminfo for safety)
# The [[ -n ... ]] check prevents errors if the terminal definition is missing.
[[ -n "${key[Insert]}" ]]    && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}" ]]    && bindkey -- "${key[Delete]}"    delete-char
[[ -n "${key[PageUp]}" ]]    && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}" reverse-menu-complete

# Smart History bindings via terminfo
if [[ -n "${key[Up]}" ]]; then
  bindkey -- "${key[Up]}" up-line-or-beginning-search
fi
if [[ -n "${key[Down]}" ]]; then
  bindkey -- "${key[Down]}" down-line-or-beginning-search
fi

# ------------------------------------------------------------------------------
# 5. MANUAL FALLBACKS (Fixes for macOS/Alacritty/Tmux/Zellij)
# ------------------------------------------------------------------------------
# Terminfo often fails to detect the specific mode Alacritty is in (Normal vs App).
# We explicitly bind common codes here to ensure they always work.

# Home / End
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line

# Up / Down (Smart Search) - Fallbacks
# This fixes the issue where Up/Down didn't work if terminfo returned empty.
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey "^[OA" up-line-or-beginning-search
bindkey "^[OB" down-line-or-beginning-search

# Delete
bindkey "^[[3~" delete-char

# Ctrl + Left/Right (Word Jumping)
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

# Alt + Left/Right (macOS style option-jumping support)
bindkey "^[b" backward-word
bindkey "^[f" forward-word
# Fallback for Alt+Arrows (often sent by Alacritty on Linux)
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word

# ------------------------------------------------------------------------------
# 6. Extra Shortcuts
# ------------------------------------------------------------------------------

# Ctrl+P / Ctrl+N (Classic history navigation)
bindkey "^p" history-search-backward
bindkey "^n" history-search-forward

# Ctrl+X -> Ctrl+E (Edit long command in default EDITOR)
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# ------------------------------------------------------------------------------
# 7. Cleanup
# ------------------------------------------------------------------------------
unset key
