export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"

# zsh reads $HOME/.zshenv before ZDOTDIR is known, and never revisits it, so
# $ZDOTDIR/.zshenv must be sourced explicitly.
[[ -r "$ZDOTDIR/.zshenv" ]] && source "$ZDOTDIR/.zshenv"
