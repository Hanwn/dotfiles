source ${ZDOTDIR}/.zshenv
source ${ZDOTDIR}/.aliases.zsh

autoload -Uz compinit
compinit

# load plugins
[[ -d ${ZDOTDIR}/conf.d ]] && for f in ${ZDOTDIR}/conf.d/*.zsh(-.N); source $f

command -v starship &> /dev/null && eval "$(starship init zsh)"
command -v zoxide &> /dev/null && eval "$(zoxide init zsh)"
command -v atuin &> /dev/null && eval "$(atuin init zsh)"
command -v sheldon &> /dev/null && eval "$(sheldon source)"
command -v mise &> /dev/null && eval "$(mise activate zsh)"
