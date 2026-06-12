source ${ZDOTDIR}/.zshenv
source ${ZDOTDIR}/.aliases.zsh

autoload -Uz compinit
local zcompdump="${ZDOTDIR}/.zcompdump"
if [[ -f "$zcompdump" ]] && [[ "$(find "$zcompdump" -mtime -1 2>/dev/null)" ]]; then
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

# load plugins
[[ -d ${ZDOTDIR}/conf.d ]] && for f in ${ZDOTDIR}/conf.d/*.zsh(-.N); source $f

command -v starship &> /dev/null && eval "$(starship init zsh)"
command -v zoxide &> /dev/null && eval "$(zoxide init zsh)"
command -v atuin &> /dev/null && eval "$(atuin init zsh)"
command -v sheldon &> /dev/null && eval "$(sheldon source)"

# ctrl-r -> atuin search (must be after atuin init)
command -v atuin &> /dev/null && bindkey '^r' atuin-search
