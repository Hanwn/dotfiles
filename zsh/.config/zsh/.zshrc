source "${ZDOTDIR}/.aliases.zsh"

# Initialize zsh completion and keep its cache under ZDOTDIR.
autoload -Uz compinit
compinit -d "${ZDOTDIR}/.zcompdump"

# bat as manpager
if command -v bat >/dev/null 2>&1; then
  export MANPAGER="bat -l man -p"
elif command -v batcat >/dev/null 2>&1; then
  export MANPAGER="batcat -l man -p"
fi

# These plugins and prompt tools use ZLE, so skip them in interactive shells
# without a terminal, such as `zsh -i -c ...`.
if [[ -o zle ]]; then
  # Load Sheldon plugins before local configuration that may use them.
  if command -v sheldon >/dev/null 2>&1; then
    eval "$(sheldon source)"
  fi

  # Keep local ZLE/plugin settings after Sheldon has loaded its plugins.
  if [[ -d "${ZDOTDIR}/conf.d" ]]; then
    for f in "${ZDOTDIR}"/conf.d/*.zsh(N); do
      [[ -r "$f" ]] || continue
      source "$f"
    done
  fi

  # Re-sourcing .zshrc must not wrap Starship's ZLE hooks repeatedly.
  if [[ -z ${__DOTFILES_STARSHIP_INITIALIZED:-} ]] && command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
    typeset -g __DOTFILES_STARSHIP_INITIALIZED=1
  fi

  command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

  # Atuin is initialized here, after fzf plugins, so its Ctrl-R binding wins.
  if command -v atuin >/dev/null 2>&1; then
    eval "$(atuin init zsh)"
    bindkey '^R' atuin-search
  fi
fi
