# Go
export GOPATH="${GOPATH:-$HOME/go}"
export GOPROXY="${GOPROXY:-https://goproxy.cn,direct}"
[[ -d "$GOPATH/bin" ]] && path=("$GOPATH/bin" $path)

# Bun
export BUN_INSTALL="${BUN_INSTALL:-$XDG_DATA_HOME/bun}"
[[ -d "$BUN_INSTALL/bin" ]] && path=("$BUN_INSTALL/bin" $path)
