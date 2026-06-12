#### fzf
if command -v fzf >/dev/null 2>&1; then
    local fzf_cache="${XDG_CACHE_HOME}/zsh/fzf-init.zsh"
    if [[ ! -f "$fzf_cache" || "$(command -v fzf)" -nt "$fzf_cache" ]]; then
        mkdir -p "${XDG_CACHE_HOME}/zsh"
        fzf --zsh > "$fzf_cache"
    fi
    source "$fzf_cache"
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
  --bind='ctrl-r:reload(atuin search $atuin_opts)'
  --color=fg:#faf9f5,bg:-1,hl:#6a9bcc
  --color=fg+:#faf9f5,bg+:-1,hl+:#6a9bcc
  --color=info:#6a9bcc,prompt:#6a9bcc,pointer:#c25848
  --color=marker:#788c5d,spinner:#c89b40,header:#6a9bcc
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
