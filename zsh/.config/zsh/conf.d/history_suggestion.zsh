# perf optimize
ZSH_AUTOSUGGEST_MANUAL_REBIND=1


HISTSIZE=10000
SAVEHIST=10000
hist_dir="${XDG_STATE_HOME:-$HOME/.local/state}/zsh"
[[ -d "$hist_dir" ]] || mkdir -p "$hist_dir"
HISTFILE="$hist_dir/history"
unset hist_dir

setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
