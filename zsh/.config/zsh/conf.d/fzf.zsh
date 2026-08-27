if (( $+commands[fzf] )); then
  local fzf_cache_home="${XDG_CACHE_HOME:-$HOME/.cache}"
  local fzf_cache="$fzf_cache_home/zsh/fzf-init.zsh"
  if [[ ! -s "$fzf_cache" || "$commands[fzf]" -nt "$fzf_cache" ]]; then
    mkdir -p "$fzf_cache_home/zsh"
    fzf --zsh >| "$fzf_cache"
  fi
  [[ -s "$fzf_cache" ]] && source "$fzf_cache"
  unset fzf_cache_home fzf_cache
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
  --color=fg:#ffffff,bg:-1,hl:#56c2ff
  --color=fg+:#ffffff,bg+:-1,hl+:#56c2ff
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

_fzf_comprun() {
  local command="$1"
  shift

  case "$command" in
    cd)
      fzf --preview 'command -v eza >/dev/null && eza --tree --color=always --icons --level=2 {} | head -200' "$@"
      ;;
    export|unset)
      fzf --preview "eval 'echo \$'{}" "$@"
      ;;
    ssh)
      fzf --preview 'command -v dig >/dev/null && dig {}' "$@"
      ;;
    *)
      fzf --preview 'command -v bat >/dev/null && bat -n --color=always {}' "$@"
      ;;
  esac
}
