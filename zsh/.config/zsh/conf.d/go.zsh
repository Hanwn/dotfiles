# go settings
export GOPATH="$(go env GOPATH 2>/dev/null || echo "$HOME/go")"
export GO111MODULE="on"
export GOPROXY="https://goproxy.cn,direct"