# Initialize zsh completion and keep its cache under ZDOTDIR.
autoload -Uz compinit
compinit -d "${ZDOTDIR}/.zcompdump"

# These plugins and prompt tools use ZLE, so skip them in interactive shells
# without a terminal, such as `zsh -i -c ...`.
if [[ -o zle ]]; then
  # Load Sheldon plugins plus local config (see plugins.toml).
  command -v sheldon >/dev/null 2>&1 && eval "$(sheldon source)"

  # Guard against re-running `starship init zsh` when .zshrc is re-sourced
  # (starship#3418). Check for the function it defines, since functions do not
  # leak into child shells (unlike STARSHIP_SHELL, which starship exports).
  (( $+functions[starship_zle-keymap-select] )) || eval "$(starship init zsh)"

  command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
  # mise (version manager). --shims is faster than the default hook-env mode;
  # only use the default if you rely on `[env]` PATH additions in .mise.toml.
  command -v mise &> /dev/null && eval "$(mise activate zsh --shims)"

  # Atuin is initialized here, after fzf plugins, so its Ctrl-R binding wins.
  if command -v atuin >/dev/null 2>&1; then
    eval "$(atuin init zsh)"
    bindkey '^R' atuin-search
  fi
fi
