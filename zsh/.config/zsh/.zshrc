
ZIM_CONFIG_FILE=~/.config/zsh/.zimrc
ZIM_HOME=~/.config/zsh/.zim

if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi
# perf optimize
ZSH_AUTOSUGGEST_MANUAL_REBIND=1


source ${ZIM_HOME}/init.zsh
source ${ZDOTDIR}/.zshenv
source ${ZDOTDIR}/.aliases

eval "$(starship init zsh)"
