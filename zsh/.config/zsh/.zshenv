export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_BIN_DIR=${XDG_BIN_DIR:-$HOME/.local/bin}

export TERM=xterm-256color
export LANGUAGE=en_US

# go settings
export GOPATH="$(go env GOPATH 2>/dev/null || echo "$HOME/go")"
export GO111MODULE="on"
export GOPROXY="https://goproxy.cn,direct"


# editor settings
export EDITOR=nvim
export VISUAL=nvim


# software config
export BUN_INSTALL=${XDG_DATA_HOME}/bun
export STARSHIP_CONFIG=${XDG_CONFIG_HOME}/starship/starship.toml

# path config
export PATH="$GOPATH/bin:$BUN_INSTALL/bin:${XDG_BIN_DIR}:$PATH"

# for linux
if [ -d "$XDG_DATA_HOME/JetBrains/Toolbox/scripts" ]; then
  export PATH="$XDG_DATA_HOME/JetBrains/Toolbox/scripts:$PATH"
fi

# for mac
if [ -d "$HOME/Library/Application Support/JetBrains/Toolbox/scripts" ]; then
  export PATH="$HOME/Library/Application Support/JetBrains/Toolbox/scripts:$PATH"
fi

local_env_file="${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}/.localenv"
if [ -r "$local_env_file" ]; then
  . "$local_env_file"
fi
unset local_env_file

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm