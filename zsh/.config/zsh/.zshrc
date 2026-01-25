
ZIM_CONFIG_FILE=$ZDOTDIR/.zimrc.zsh
ZIM_HOME=$ZDOTDIR/.zim

if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc.zsh} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi


# load plugins
[[ -d ${ZDOTDIR}/plugins ]] && for f in ${ZDOTDIR}/plugins/*.zsh(.N); source $f


source ${ZIM_HOME}/init.zsh
source ${ZDOTDIR}/.zshenv
source ${ZDOTDIR}/.aliases.zsh

# install starship
if ! command -v starship >/dev/null 2>&1; then
  if [[ -o interactive ]] && command -v curl >/dev/null 2>&1; then
    echo "[zsh] starship not found, installing..."
    curl -fsSL https://starship.rs/install.sh | sh -s -- --yes >/dev/null 2>&1
  fi
fi

eval "$(starship init zsh)"
