ZVM_CURSOR_STYLE_ENABLED=false

function zvm_after_init() {
  zvm_bindkey viins '^R' atuin-search
  zvm_bindkey vicmd '^R' atuin-search
}
