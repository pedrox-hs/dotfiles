# Detects the current kernel name (linux, darwin, etc.)
# and sources the corresponding profile file.

__kernel_name=$(uname -s | tr '[:upper:]' '[:lower:]')
__kernel_profile="$DOTFILES_DIR/$__kernel_name.zsh"

source_if_exists "$__kernel_profile"

unset __kernel_name __kernel_profile
