export ATUIN_NOBIND="true"
eval "$(atuin init zsh)"

ZVM_CURSOR_STYLE_ENABLED=false

# fix conflict with fzf
function zvm_after_init() {
  # zvm_bindkey viins '^R' fzf-history-widget
  bindkey '^r' atuin-search
}
