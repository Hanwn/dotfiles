ZVM_CURSOR_STYLE_ENABLED=false

export ATUIN_NOBIND="true"

function zvm_after_init() {
    # zvm_bindkey viins '^R' fzf-history-widget
    bindkey '^r' atuin-search
}

