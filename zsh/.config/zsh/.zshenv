# XDG base directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_BIN_DIR="${XDG_BIN_DIR:-$HOME/.local/bin}"

# locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# editor
export EDITOR="nvim"
export VISUAL="nvim"

# pager
export PAGER="less"
export LESS="-R -M --shift 5"
export LESSHISTFILE="-"

# GPG (for signed git commits in terminal)
export GPG_TTY="${TTY:-$(tty)}"

# paths
export PATH="${XDG_BIN_DIR}:$PATH"
export MANPATH="${XDG_DATA_HOME}/man:${MANPATH:-}"

# dedup PATH/MANPATH/FPATH entries
typeset -U path fpath manpath

# machine-local overrides (gitignored)
local_env_file="${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}/.local.env"
if [[ -r "$local_env_file" ]]; then
  source "$local_env_file"
fi
unset local_env_file
