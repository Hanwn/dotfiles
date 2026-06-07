#### fzf
if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi

# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='**'

# Raycast Dark 配色 + 全局外观/交互
export FZF_DEFAULT_OPTS="
  --height=60%
  --layout=reverse
  --border=rounded
  --margin=0,1
  --info=inline-right
  --prompt='> '
  --pointer='▶'
  --marker='✓'
  --bind='ctrl-y:accept'
  --bind='ctrl-u:preview-half-page-up'
  --bind='ctrl-d:preview-half-page-down'
  --bind='ctrl-/:toggle-preview'
  --color=fg:#ffffff,bg:#1a1a1a,hl:#56c2ff
  --color=fg+:#ffffff,bg+:#333333,hl+:#56c2ff
  --color=info:#56c2ff,prompt:#56c2ff,pointer:#ff5360
  --color=marker:#59d499,spinner:#ffc531,header:#56c2ff
"

# Options for completion
export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_COMPLETION_PATH_OPTS='--walker file,dir,follow,hidden'
export FZF_COMPLETION_DIR_OPTS='--walker dir,follow'

# fd 集成
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# CTRL-T: 文件搜索预览
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always --line-range :500 {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
"

# ALT-C: 目录跳转预览
export FZF_ALT_C_OPTS="
  --preview 'eza --tree --color=always --icons --level=2 {} | head -200'
"

# CTRL-R: 历史搜索增强
# export FZF_CTRL_R_OPTS="
#   --preview 'echo {}'
#   --preview-window 'up:3:hidden:wrap'
#   --bind 'ctrl-/:toggle-preview'
#   --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
#   --header 'CTRL-Y: copy to clipboard'
# "

# Advanced customization of fzf options via _fzf_comprun function
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always --icons --level=2 {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}



#### CTRL-R: 用 atuin 的数据给 fzf 做模糊查询
# 坑点：
#   1. 上面 `source <(fzf --zsh)` 已经把 ^R 绑到 fzf-history-widget（读 zsh 自己的历史）
#   2. zsh-vi-mode (zvm) 通过 sheldon 加载，会延迟到第一个 precmd 才 zvm_init，
#      初始化时 **会清空所有自定义 keymap**，普通的 bindkey 会被它吹掉，
#      表现为按 ^R 时回退到 zsh 内置的 `bck-i-search:` 提示。
#   3. atuin init 在 ATUIN_NOBIND=true 下不绑键，只注册 widget。
# 解决：定义自己的 widget，并把 bindkey 注册同时挂到 zvm_after_init_commands 钩子，
# 既覆盖 fzf 的默认绑定，又能在 zvm 清空 keymap 后再绑回来。
if command -v atuin >/dev/null 2>&1; then
  _atuin_fzf_history() {
    emulate -L zsh
    local selected
    # atuin history list --cmd-only --reverse 是新→旧；fzf --no-sort 保持该顺序
    # awk 去重保留首次出现（即最近一次执行）
    selected=$(
      atuin history list --cmd-only --reverse \
        | awk '!seen[$0]++' \
        | fzf \
            --no-sort \
            --exact \
            --tiebreak=index \
            --scheme=history \
            --query="$LBUFFER" \
            --prompt='atuin> ' \
            --bind='ctrl-y:accept'
    )
    local ret=$?
    if [[ -n $selected ]]; then
      LBUFFER=$selected
      RBUFFER=''
    fi
    zle reset-prompt
    return $ret
  }
  zle -N _atuin_fzf_history

  _atuin_fzf_bind() {
    bindkey '^R' _atuin_fzf_history
    bindkey -M viins '^R' _atuin_fzf_history 2>/dev/null
    bindkey -M vicmd '^R' _atuin_fzf_history 2>/dev/null
    bindkey -M emacs '^R' _atuin_fzf_history 2>/dev/null
  }

  # 立即绑一次（zvm 不存在时这就够了），并挂到 zvm 钩子兜底（zvm init 会清 keymap）
  typeset -ga zvm_after_init_commands
  zvm_after_init_commands+=(_atuin_fzf_bind)
  _atuin_fzf_bind
fi

