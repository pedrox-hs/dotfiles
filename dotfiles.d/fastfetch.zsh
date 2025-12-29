# Show system info only on first pane of a Zellij session
if [[ -n "$ZELLIJ" ]] && command -v fastfetch >/dev/null; then
  # Marker file unique to the current Zellij session
  _zellij_marker="${XDG_RUNTIME_DIR:-/tmp}/zellij_welcome_${ZELLIJ_SESSION_NAME}"

  if [[ ! -f "$_zellij_marker" ]]; then
    echo -e '\n'
    fastfetch
    touch "$_zellij_marker"
  fi

  unset _zellij_marker
fi