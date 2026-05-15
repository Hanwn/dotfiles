#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES_DIR"

info() { printf "\033[1;34m[INFO]\033[0m %s\n" "$*"; }
ok()   { printf "\033[1;32m[OK]\033[0m   %s\n" "$*"; }

# ── install stow via system package manager ──────────────────────────
install_stow() {
  if command -v stow &>/dev/null; then
    ok "stow ready: $(stow --version | head -1)"
    return
  fi
  info "Installing stow..."
  if [[ "$OSTYPE" == darwin* ]]; then
    brew install stow
  elif command -v apk &>/dev/null; then
    sudo apk add --no-cache stow
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y stow
  elif command -v apt-get &>/dev/null; then
    sudo apt-get install -y stow
  else
    echo "Please install stow manually"; exit 1
  fi
  ok "stow installed"
}

# ── install Homebrew ─────────────────────────────────────────────────
install_brew() {
  if command -v brew &>/dev/null; then
    ok "brew ready: $(brew --version | head -1)"
    return
  fi
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # make brew available in current shell
  if [[ "$OSTYPE" == darwin* ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
  ok "brew installed"
}

# ── brew bundle ──────────────────────────────────────────────────────
run_brew_bundle() {
  info "Running brew bundle..."
  brew bundle --file="$DOTFILES_DIR/Brewfile"
  ok "brew bundle done"
}

# ── stow dotfiles ───────────────────────────────────────────────────
link_dotfiles() {
  info "Linking dotfiles..."
  for pkg in */; do
    pkg="${pkg%/}"
    [[ -d "$pkg" ]] || continue
    [[ "$pkg" == ".git" || "$pkg" == ".github" || "$pkg" == ".devcontainer" || "$pkg" == ".claude" || "$pkg" == "local" ]] && continue

    # link top-level dotfiles (e.g. zsh/.zshenv → ~/.zshenv)
    if ls "$pkg"/.* 2>/dev/null | grep -q /; then
      stow --dir="$DOTFILES_DIR" --target="$HOME" "$pkg" 2>/dev/null || true
    fi

    # link .config subdirectories
    if [[ -d "$pkg/.config" ]]; then
      mkdir -p "$HOME/.config"
      for sub in "$pkg/.config"/*/; do
        sub="${sub%/}"; sub="$(basename "$sub")"
        stow --dir="$pkg/.config" --target="$HOME/.config" "$sub" 2>/dev/null || true
      done
    fi
    ok "Linked: $pkg"
  done
  ok "Dotfiles linked"
}

# ── create local config templates if missing ───────────────────────
create_local_configs() {
  info "Creating local config templates if missing..."

  local gitconfig="$HOME/.config/git/config.local"
  if [[ ! -f "$gitconfig" ]]; then
    mkdir -p "$(dirname "$gitconfig")"
    cat > "$gitconfig" <<'EOF'
[user]
    name = Your Name
    email = your.email@example.com
EOF
    ok "Created template: $gitconfig"
  else
    ok "Exists: $gitconfig"
  fi

  local localenv="$HOME/.config/zsh/.local.env"
  if [[ ! -f "$localenv" ]]; then
    mkdir -p "$(dirname "$localenv")"
    cat > "$localenv" <<'EOF'
# Local environment variables (not tracked by git)
# source "${XDG_DATA_HOME}/clashctl/scripts/cmd/clashctl.sh"
# export TP_API_KEY="your-api-key"
EOF
    ok "Created template: $localenv"
  else
    ok "Exists: $localenv"
  fi
}

# ── main ────────────────────────────────────────────────────────────
main() {
  info "Starting dotfiles setup from $DOTFILES_DIR"
  install_stow
  install_brew
  run_brew_bundle
  link_dotfiles
  create_local_configs
  ok "Done! Restart your shell or run: source ~/.zshenv"
}

main "$@"
