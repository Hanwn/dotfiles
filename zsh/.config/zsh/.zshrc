source ${ZDOTDIR}/.zshenv
source ${ZDOTDIR}/.aliases.zsh


if [ -d "$HOME/.linuxbrew" ]; then
  eval "$($HOME/.linuxbrew/bin/brew shellenv)"
fi

if [ -d "/home/linuxbrew/.linuxbrew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if [ -d "/opt/homebrew/bin" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if command -v brew >/dev/null 2>&1; then
    fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
fi





# load plugins
[[ -d ${ZDOTDIR}/conf.d ]] && for f in ${ZDOTDIR}/conf.d/*.zsh(.N); source $f



command -v starship &> /dev/null && eval "$(starship init zsh)"
command -v zoxide &> /dev/null && eval "$(zoxide init zsh)"
command -v sheldon &> /dev/null && eval "$(sheldon source)"
command -v atuin &> /dev/null && eval "$(atuin init zsh)"
command -v mise &> /dev/null && eval "$(mise activate zsh)"
