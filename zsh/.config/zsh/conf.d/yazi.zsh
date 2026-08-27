function y() {
  (( $+commands[yazi] )) || return 127

  local tmp cwd
  tmp="$(mktemp "${TMPDIR:-/tmp}/yazi-cwd.XXXXXX")" || return
  trap 'rm -f -- "$tmp"' RETURN

  command yazi "$@" --cwd-file="$tmp" || return
  if [[ -r "$tmp" ]]; then
    IFS= read -r -d '' cwd < "$tmp"
    [[ "$cwd" != "$PWD" && -d "$cwd" ]] && builtin cd -- "$cwd"
  fi
}
