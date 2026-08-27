#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES_DIR"

# ── output helpers ──────────────────────────────────────────────────
info() { printf "\033[1;34m[INFO]\033[0m %s\n" "$*"; }
ok() { printf "\033[1;32m[ OK ]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[WARN]\033[0m %s\n" "$*" >&2; }
err() { printf "\033[1;31m[ERR]\033[0m  %s\n" "$*" >&2; }

# Packages to skip when stowing. Add a package here only when it should not
# expose files under $HOME.
SKIP_PKGS=(local)

# Runtime and machine-local files must stay local to the target machine.
# Keeping these out of stow also prevents ignored files in the checkout from
# being linked accidentally.
STOW_IGNORE_ARGS=(
  --ignore='(^|/)\.local\.env$'
  --ignore='(^|/)config\.local$'
  --ignore='(^|/)\.zcompdump.*$'
  --ignore='(^|/)\.zhistory$'
  --ignore='(^|/)\.zcompcache$'
)

is_skipped_package() {
  local package="$1"
  local skipped

  for skipped in "${SKIP_PKGS[@]}"; do
    [[ "$package" == "$skipped" ]] && return 0
  done
  return 1
}


# ── install stow via system package manager ──────────────────────────
install_stow() {
  if command -v stow &>/dev/null; then
    ok "stow ready: $(stow --version | head -1)"
    return
  fi
  info "Installing stow..."
  if [[ "$OSTYPE" == darwin* ]]; then
    install_brew
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
  brew bundle --file="$DOTFILES_DIR/Brewfile"
  ok "brew bundle done"
}

# ── stow dotfiles ───────────────────────────────────────────────────
link_dotfiles() {
  info "Linking dotfiles..."
  local failed=0
  local package

  # Every non-hidden top-level directory is a stow package. This means adding
  # a new tool only requires creating its package directory.
  for package in */; do
    package="${package%/}"
    [[ "$package" == .* ]] && continue
    is_skipped_package "$package" && continue

    # --restow is idempotent. --adopt moves existing target files into this
    # package before linking them, which is intentional for this personal
    # configuration repository.
    if stow \
      --restow \
      --no-folding \
      --adopt \
      --target="$HOME" \
      "${STOW_IGNORE_ARGS[@]}" \
      "$package"; then
      ok "Linked: $package"
    else
      warn "Failed to link: $package"
      failed=$((failed + 1))
    fi
  done

  if ((failed > 0)); then
    err "$failed package(s) failed to link — resolve conflicts and rerun"
    return 1
  else
    ok "All dotfiles linked"
  fi
}

# ── create local config templates if missing ───────────────────────
create_local_configs() {
  info "Creating local config templates if missing..."

  _ensure_template() {
    local path="$1" content="$2"
    if [[ ! -f "$path" ]]; then
      mkdir -p "$(dirname "$path")"
      printf '%s\n' "$content" >"$path"
      ok "Created: $path"
    else
      ok "Exists:  $path"
    fi
  }

  _ensure_template "$HOME/.config/git/config.local" '[user]
    name = Your Name
    email = your.email@example.com'

  _ensure_template "$HOME/.config/zsh/.local.env" '# Local environment variables (not tracked by git)
# source "${XDG_DATA_HOME}/clashctl/scripts/cmd/clashctl.sh"
# export TP_API_KEY="your-api-key"'
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
