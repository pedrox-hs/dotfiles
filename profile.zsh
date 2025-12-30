DOTFILES_ROOT="${DOTFILES_ROOT-$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )}"
DOTFILES_DIR="$DOTFILES_ROOT/dotfiles.d"
DOTFILES_CONFIG="$DOTFILES_ROOT/config"

# Helper function to source files if they exist
# Usage: source_if_exists "file1" "file2" ...
function source_if_exists() {
  for file in "$@"; do
    [[ -s "$file" ]] && source "$file"
  done
}

source_if_exists \
  "$DOTFILES_ROOT/.env.default" \
  "$DOTFILES_ROOT/.env"

source  "$DOTFILES_DIR/main.zsh"

unset DOTFILES_DIR DOTFILES_CONFIG
