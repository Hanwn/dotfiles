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

# zerobrew completions
if [[ -d "/opt/zerobrew/share/zsh/site-functions" ]]; then
  fpath=("/opt/zerobrew/share/zsh/site-functions" $fpath)
fi



# load plugins
[[ -d ${ZDOTDIR}/plugins ]] && for f in ${ZDOTDIR}/plugins/*.zsh(.N); source $f


source ${ZDOTDIR}/.zshenv
source ${ZDOTDIR}/.aliases.zsh


eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(sheldon source)"
eval "$(atuin init zsh)"
eval "$(mise activate zsh)"
