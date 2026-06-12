# login shell setup — runs once per login

# Homebrew (supports ~/.linuxbrew, /home/linuxbrew, /opt/homebrew)
case "$OSTYPE" in
  linux*)
    [[ -d "$HOME/.linuxbrew" ]] && eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
    [[ -d "/home/linuxbrew/.linuxbrew" ]] && eval "$("/home/linuxbrew/.linuxbrew/bin/brew" shellenv)"
    ;;
  darwin*)
    [[ -d "/opt/homebrew/bin" ]] && eval "$("/opt/homebrew/bin/brew" shellenv)"
    ;;
esac

# brew site-functions
if command -v brew >/dev/null 2>&1; then
    fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
    export HOMEBREW_NO_ENV_HINTS=1
fi

# mise (version manager)
command -v mise &> /dev/null && eval "$(mise activate zsh)"
