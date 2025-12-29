# https://asdf-vm.com/guide/getting-started.html
export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"

if [[ -d "$ASDF_DATA_DIR" ]]; then
  export PATH="$ASDF_DATA_DIR/shims:$PATH"

  # Initialize completions if missing
  __asdf_completions="$ASDF_DATA_DIR/completions"
  if [[ ! -d "$__asdf_completions" ]]; then
    mkdir -p "$__asdf_completions"
    asdf completion zsh > "$__asdf_completions/_asdf"
  fi

  fpath=(${__asdf_completions} $fpath)
  unset __asdf_completions
fi
