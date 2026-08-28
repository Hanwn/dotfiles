source "${ZDOTDIR}/.aliases.zsh"

autoload -Uz compinit
local zcompdump="${ZDOTDIR}/.zcompdump"
if [[ -f "$zcompdump" ]]; then
  compinit -C -d "$zcompdump"
else
  compinit -d "$zcompdump"
fi

# starship config
export STARSHIP_CONFIG="${XDG_CONFIG_HOME}/starship/starship.toml"

# bat as manpager
if command -v bat >/dev/null 2>&1; then
  export MANPAGER="bat -l man -p"
elif command -v batcat >/dev/null 2>&1; then
  export MANPAGER="batcat -l man -p"
fi

# ZLE-dependent plugins should not initialize in interactive shells without a
# terminal, such as `zsh -i -c ...`.
if [[ -o zle ]]; then
  if command -v sheldon >/dev/null 2>&1; then
    eval "$(sheldon source)"
  fi

  if [[ -d "${ZDOTDIR}/conf.d" ]]; then
    for f in "${ZDOTDIR}"/conf.d/*.zsh(N); do
      [[ -r "$f" ]] || continue
      source "$f"
    done
  fi
fi

if [[ -o zle ]]; then
  command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
  command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
  command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"
fi
