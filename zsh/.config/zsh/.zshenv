export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_BIN_DIR=${XDG_BIN_DIR:-$HOME/.local/bin}

export TERM=xterm-256color
export LANGUAGE=en_US

# editor settings
export EDITOR=nvim
export VISUAL=nvim

local_env_file="${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}/.local.env"
if [ -r "$local_env_file" ]; then
  . "$local_env_file"
fi
unset local_env_file

export PATH="$HOME/.local/bin:$PATH"