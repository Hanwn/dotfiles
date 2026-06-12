# perf optimize
ZSH_AUTOSUGGEST_MANUAL_REBIND=1


HISTSIZE=10000
SAVEHIST=10000
HISTFILE=${ZDOTDIR:-$HOME}/.zhistory

setopt EXTENDED_HISTORY        # add timestamps to history
setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY  # adds history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS
