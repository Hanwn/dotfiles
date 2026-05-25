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