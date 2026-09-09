# Language toolchains follow the XDG base-directory layout where supported.
# Every value remains overridable from the environment or .local.env.

# Go
export GOPATH="${GOPATH:-$XDG_DATA_HOME/go}"
export GOBIN="${GOBIN:-$XDG_BIN_DIR}"
export GOCACHE="${GOCACHE:-$XDG_CACHE_HOME/go-build}"
export GOMODCACHE="${GOMODCACHE:-$XDG_CACHE_HOME/go-mod}"
export GOENV="${GOENV:-$XDG_CONFIG_HOME/go/env}"
export GOPROXY="${GOPROXY:-https://goproxy.cn,direct}"

# Rust and Cargo. Keep target directories project-local so build profiles and
# toolchains from unrelated projects do not share artifacts.
export CARGO_HOME="${CARGO_HOME:-$XDG_DATA_HOME/cargo}"
export RUSTUP_HOME="${RUSTUP_HOME:-$XDG_DATA_HOME/rustup}"

# Node.js and package managers
export NODE_REPL_HISTORY="${NODE_REPL_HISTORY:-$XDG_STATE_HOME/node/repl_history}"
export COREPACK_HOME="${COREPACK_HOME:-$XDG_CACHE_HOME/node/corepack}"

export NPM_CONFIG_CACHE="${NPM_CONFIG_CACHE:-$XDG_CACHE_HOME/npm}"
export NPM_CONFIG_USERCONFIG="${NPM_CONFIG_USERCONFIG:-$XDG_CONFIG_HOME/npm/npmrc}"
export NPM_CONFIG_PREFIX="${NPM_CONFIG_PREFIX:-$XDG_DATA_HOME/npm}"

export PNPM_HOME="${PNPM_HOME:-$XDG_DATA_HOME/pnpm}"

export YARN_CACHE_FOLDER="${YARN_CACHE_FOLDER:-$XDG_CACHE_HOME/yarn}"
export YARN_GLOBAL_FOLDER="${YARN_GLOBAL_FOLDER:-$XDG_DATA_HOME/yarn/global}"

export BUN_INSTALL="${BUN_INSTALL:-$XDG_DATA_HOME/bun}"
export BUN_INSTALL_CACHE_DIR="${BUN_INSTALL_CACHE_DIR:-$XDG_CACHE_HOME/bun/install}"

export DENO_INSTALL="${DENO_INSTALL:-$XDG_DATA_HOME/deno}"
export DENO_DIR="${DENO_DIR:-$XDG_CACHE_HOME/deno}"

export VOLTA_HOME="${VOLTA_HOME:-$XDG_DATA_HOME/volta}"

# Python, pip, uv, IPython, and Jupyter
export PYTHONUSERBASE="${PYTHONUSERBASE:-$XDG_DATA_HOME/python}"
export PYTHON_HISTORY="${PYTHON_HISTORY:-$XDG_STATE_HOME/python/history}"
export PIP_CACHE_DIR="${PIP_CACHE_DIR:-$XDG_CACHE_HOME/pip}"
export PIP_CONFIG_FILE="${PIP_CONFIG_FILE:-$XDG_CONFIG_HOME/pip/pip.conf}"

export UV_CACHE_DIR="${UV_CACHE_DIR:-$XDG_CACHE_HOME/uv}"
export UV_PYTHON_INSTALL_DIR="${UV_PYTHON_INSTALL_DIR:-$XDG_DATA_HOME/uv/python}"
export UV_TOOL_DIR="${UV_TOOL_DIR:-$XDG_DATA_HOME/uv/tools}"
export UV_TOOL_BIN_DIR="${UV_TOOL_BIN_DIR:-$XDG_BIN_DIR}"

export IPYTHONDIR="${IPYTHONDIR:-$XDG_CONFIG_HOME/ipython}"
export JUPYTER_CONFIG_DIR="${JUPYTER_CONFIG_DIR:-$XDG_CONFIG_HOME/jupyter}"
export JUPYTER_DATA_DIR="${JUPYTER_DATA_DIR:-$XDG_DATA_HOME/jupyter}"
export JUPYTER_RUNTIME_DIR="${JUPYTER_RUNTIME_DIR:-$XDG_STATE_HOME/jupyter/runtime}"

# Java and .NET
export GRADLE_USER_HOME="${GRADLE_USER_HOME:-$XDG_DATA_HOME/gradle}"

export DOTNET_CLI_HOME="${DOTNET_CLI_HOME:-$XDG_DATA_HOME/dotnet}"
export NUGET_PACKAGES="${NUGET_PACKAGES:-$XDG_CACHE_HOME/NuGet/packages}"
export NUGET_HTTP_CACHE_PATH="${NUGET_HTTP_CACHE_PATH:-$XDG_CACHE_HOME/NuGet/http-cache}"
export NUGET_PLUGINS_CACHE_PATH="${NUGET_PLUGINS_CACHE_PATH:-$XDG_CACHE_HOME/NuGet/plugins-cache}"

# Developer assistants
export CODEX_HOME="${CODEX_HOME:-$XDG_CONFIG_HOME/codex}"
export CLAUDE_CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$XDG_CONFIG_HOME/claude}"

# User-installed executables. zsh keeps PATH tied to the path array, and the
# unique attribute removes duplicates while retaining the first occurrence.
path=(
  "$XDG_BIN_DIR"
  "$CARGO_HOME/bin"
  "$NPM_CONFIG_PREFIX/bin"
  "$PNPM_HOME"
  "$BUN_INSTALL/bin"
  "$DENO_INSTALL/bin"
  "$VOLTA_HOME/bin"
  "$PYTHONUSERBASE/bin"
  "$DOTNET_CLI_HOME/.dotnet/tools"
  $path
)
typeset -U path
export PATH
