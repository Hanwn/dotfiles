ZVM_CURSOR_STYLE_ENABLED=false

export ATUIN_NOBIND="true"

function zvm_after_init() {
  bindkey '^r' atuin-search
}
