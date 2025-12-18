

export LANGUAGE=en_US

# go settings
export GOPATH="$(go env GOPATH 2>/dev/null || echo "$HOME/go")"
export GO111MODULE="on"
export GOPROXY="https://goproxy.cn,direct"


# editor settings
export EDITOR=nvim
export VISUAL=nvim


# path config
export PATH="$GOPATH/bin:$HOME/.local/bin:$PATH"


if [ -d "$XDG_DATA_HOME/JetBrains/Toolbox/scripts" ]; then
  export PATH="$XDG_DATA_HOME/JetBrains/Toolbox/scripts:$PATH"
fi
