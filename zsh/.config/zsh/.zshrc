
ZIM_CONFIG_FILE=$ZDOTDIR/.zimrc.zsh
ZIM_HOME=$ZDOTDIR/.zim

if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc.zsh} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi


# Homebrew - cross-platform setup (Linux: /home/linuxbrew/.linuxbrew, macOS: /opt/homebrew)
# Must be early to ensure Homebrew paths are set for other tools
if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
elif [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
fi
# brew completion
if command -v brew >/dev/null; then
  fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
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
eval "$(zoxide init zsh)"
