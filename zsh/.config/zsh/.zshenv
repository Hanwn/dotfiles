

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
export PATH="$GOPATH/bin:${XDG_BIN_DIR}:$BUN_INSTALL/bin:$PATH"

# for linux
if [ -d "$XDG_DATA_HOME/JetBrains/Toolbox/scripts" ]; then
  export PATH="$XDG_DATA_HOME/JetBrains/Toolbox/scripts:$PATH"
fi

# for mac
if [ -d "$HOME/Library/Application Support/JetBrains/Toolbox/scripts" ]; then
  export PATH="$HOME/Library/Application Support/JetBrains/Toolbox/scripts:$PATH"
fi
