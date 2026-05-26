#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES_DIR"

# ── output helpers ──────────────────────────────────────────────────
info() { printf "\033[1;34m[INFO]\033[0m %s\n" "$*"; }
ok()   { printf "\033[1;32m[ OK ]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[WARN]\033[0m %s\n" "$*" >&2; }
err()  { printf "\033[1;31m[ERR]\033[0m  %s\n" "$*" >&2; }

# Packages to skip when stowing (hidden dirs are always skipped)
SKIP_PKGS=(local)

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
    err "Cannot detect package manager — please install stow manually"
    exit 1
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
  brew bundle --file="$DOTFILES_DIR/Brewfile" --no-lock
  ok "brew bundle done"
}

# ── stow dotfiles ───────────────────────────────────────────────────
link_dotfiles() {
  info "Linking dotfiles..."
  local failed=0

  for pkg in */; do
    pkg="${pkg%/}"

    # skip hidden dirs and explicit skip list
    [[ "$pkg" == .* ]] && continue
    printf '%s\n' "${SKIP_PKGS[@]}" | grep -qxF "$pkg" && continue

    # --restow: idempotent (unstow then stow)
    # --no-folding: symlink individual files, never entire directories
    if stow --restow --no-folding --target="$HOME" "$pkg" 2>&1; then
      ok "Linked: $pkg"
    else
      warn "Failed to link: $pkg"
      ((failed++))
    fi
  done

  if ((failed > 0)); then
    warn "$failed package(s) had stow conflicts — resolve manually"
  else
    ok "All dotfiles linked"
  fi
}

# ── create local config templates if missing ───────────────────────
create_local_configs() {
  info "Creating local config templates if missing..."

  local -A templates=(
    ["$HOME/.config/git/config.local"]='[user]
    name = Your Name
    email = your.email@example.com'
    ["$HOME/.config/zsh/.local.env"]='# Local environment variables (not tracked by git)
# source "${XDG_DATA_HOME}/clashctl/scripts/cmd/clashctl.sh"
# export TP_API_KEY="your-api-key"'
  )

  for path in "${!templates[@]}"; do
    if [[ ! -f "$path" ]]; then
      mkdir -p "$(dirname "$path")"
      printf '%s\n' "${templates[$path]}" > "$path"
      ok "Created: $path"
    else
      ok "Exists:  $path"
    fi
  done
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
