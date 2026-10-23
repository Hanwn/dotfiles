#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES_DIR"

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"
BREWFILE_HASH_FILE="$STATE_DIR/brewfile.sha256"
SKIP_PACKAGES=0

# ── output helpers ──────────────────────────────────────────────────
info() { printf "\033[1;34m[INFO]\033[0m %s\n" "$*"; }
ok() { printf "\033[1;32m[ OK ]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[WARN]\033[0m %s\n" "$*" >&2; }
err() { printf "\033[1;31m[ERR]\033[0m  %s\n" "$*" >&2; }

usage() {
  cat <<'USAGE'
Usage: ./install.sh [OPTIONS]

Options:
  --skip-packages  Skip installing/updating software packages; still create dotfile links.
  -h, --help       Show this help.
USAGE
}

parse_args() {
  while (($# > 0)); do
    case "$1" in
      --skip-packages)
        SKIP_PACKAGES=1
        ;;
      -h | --help)
        usage
        exit 0
        ;;
      *)
        err "Unknown option: $1"
        usage >&2
        exit 2
        ;;
    esac
    shift
  done
}

# Packages to skip when stowing. Add a package here only when it should not
# expose files under $HOME.
SKIP_PKGS=(local)

# Runtime and machine-local files must stay local to the target machine.
# Keeping these out of stow also prevents ignored files in the checkout from
# being linked accidentally.
STOW_IGNORE_PATTERNS=(
  '(^|/)\.local\.env$'
  '(^|/)config\.local$'
  '(^|/)\.zcompdump.*$'
  '(^|/)\.zhistory$'
  '(^|/)\.zcompcache$'
)

is_skipped_package() {
  local package="$1"
  local skipped

  for skipped in "${SKIP_PKGS[@]}"; do
    [[ "$package" == "$skipped" ]] && return 0
  done
  return 1
}

is_ignored_path() {
  local path="$1"
  local pattern

  for pattern in "${STOW_IGNORE_PATTERNS[@]}"; do
    [[ "$path" =~ $pattern ]] && return 0
  done
  return 1
}

build_stow_ignore_args() {
  local pattern

  for pattern in "${STOW_IGNORE_PATTERNS[@]}"; do
    echo "--ignore=$pattern"
  done
}

cleanup_stale_links() {
  info "Cleaning stale dotfile links..."
  local package entry root link link_target
  local -a roots=()
  local existing removed=0

  # Collect top-level target directories from all packages
  for package in "$@"; do
    for entry in \
      "$DOTFILES_DIR/$package"/* \
      "$DOTFILES_DIR/$package"/.[!.]* \
      "$DOTFILES_DIR/$package"/..?*; do
      [[ -e "$entry" || -L "$entry" ]] || continue
      root="$HOME/${entry#"$DOTFILES_DIR/$package/"}"

      # Bash 3.2 (macOS system bash) treats empty array as unbound with nounset
      if ((${#roots[@]} > 0)); then
        for existing in "${roots[@]}"; do
          [[ "$root" == "$existing" ]] && continue 2
        done
      fi
      roots+=("$root")
    done
  done

  # Find and remove broken symlinks pointing to this dotfiles repo
  if ((${#roots[@]} > 0)); then
    for root in "${roots[@]}"; do
      [[ -e "$root" || -L "$root" ]] || continue
      while IFS= read -r -d '' link; do
        link_target="$(readlink "$link" 2>/dev/null || true)"
        if [[ "$link_target" == "$DOTFILES_DIR"/* ]] || [[ "$link_target" == ../* ]]; then
          # Check if target exists (relative links need to be resolved from link dir)
          if [[ ! -e "$link" ]]; then
            unlink "$link"
            ok "Removed stale link: $link"
            removed=$((removed + 1))
          fi
        fi
      done < <(find "$root" -type l -print0 2>/dev/null || true)
    done
  fi

  if ((removed > 0)); then
    ok "Removed $removed stale link(s)"
  fi
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

require_stow() {
  if ! command -v stow &>/dev/null; then
    err "stow is required when using --skip-packages — install it manually before retrying"
    return 1
  fi
  ok "stow ready: $(stow --version | head -1)"
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
  local current_hash previous_hash

  current_hash="$(shasum -a 256 "$DOTFILES_DIR/Brewfile" | cut -d' ' -f1)"

  if [[ -f "$BREWFILE_HASH_FILE" ]]; then
    previous_hash="$(cat "$BREWFILE_HASH_FILE")"
    if [[ "$current_hash" == "$previous_hash" ]]; then
      ok "Brewfile unchanged, skipping brew bundle"
      return
    fi
  fi

  info "Running brew bundle..."
  brew bundle --file="$DOTFILES_DIR/Brewfile"

  mkdir -p "$STATE_DIR"
  echo "$current_hash" > "$BREWFILE_HASH_FILE"
  ok "brew bundle done"
}

# ── stow dotfiles ───────────────────────────────────────────────────
link_dotfiles() {
  info "Linking dotfiles..."
  local failed=0
  local package
  local -a packages=() stow_ignore_args=()

  # Build stow ignore arguments from patterns
  while IFS= read -r arg; do
    stow_ignore_args+=("$arg")
  done < <(build_stow_ignore_args)

  # Collect packages to stow
  for package in */; do
    package="${package%/}"
    [[ "$package" == .* ]] && continue
    is_skipped_package "$package" && continue
    packages+=("$package")
  done

  cleanup_stale_links "${packages[@]}"

  for package in "${packages[@]}"; do
    # --restow is idempotent. --adopt moves existing target files into this
    # package before linking them, which is intentional for this personal
    # configuration repository.
    if stow \
      --restow \
      --no-folding \
      --adopt \
      --target="$HOME" \
      "${stow_ignore_args[@]}" \
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

# ── link Herdr smart-splits backend ──────────────────────────────────
link_herdr_smart_splits_backend() {
  local plugin_id="smart-splits-backend-herdr"
  local plugin_dir="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/lazy/$plugin_id"

  if ! command -v herdr &>/dev/null; then
    warn "Skipping Herdr smart-splits backend: herdr is not installed"
    return
  fi

  if [[ ! -f "$plugin_dir/herdr-plugin.toml" ]]; then
    warn "Skipping Herdr smart-splits backend: Neovim plugin not installed at $plugin_dir"
    return
  fi

  if herdr plugin list 2>/dev/null | grep -Fq -- "$plugin_id"; then
    ok "Herdr smart-splits backend already linked"
  elif herdr plugin link "$plugin_dir"; then
    ok "Linked Herdr smart-splits backend"
  else
    warn "Could not link Herdr smart-splits backend"
    return
  fi

  if herdr plugin enable "$plugin_id" >/dev/null; then
    ok "Enabled Herdr smart-splits backend"
  else
    warn "Could not enable Herdr smart-splits backend"
  fi
}

# ── create local config files if missing ───────────────────────────
create_local_configs() {
  info "Creating local config files if missing..."

  _ensure_local_file() {
    local path="$1" content="$2"

    # Local config files must remain regular files under $HOME. If an older
    # installation left a symlink here, materialize its contents before
    # continuing so stow can never be the owner of these machine-local files.
    if [[ -L "$path" ]]; then
      local materialized
      if [[ -f "$path" ]]; then
        materialized="$(mktemp "${path}.XXXXXX")"
        cp -p "$path" "$materialized"
        mv -f "$materialized" "$path"
        ok "Materialized local file: $path"
      else
        unlink "$path"
      fi
    fi

    if [[ ! -f "$path" ]]; then
      mkdir -p "$(dirname "$path")"
      printf '%s\n' "$content" >"$path"
      ok "Created: $path"
    else
      ok "Exists:  $path"
    fi
  }

  _ensure_local_file "$HOME/.config/git/config.local" '[user]
    name = Your Name
    email = your.email@example.com'

  _ensure_local_file "$HOME/.config/zsh/.local.env" '# Local environment variables (not tracked by git)
# source "${XDG_DATA_HOME}/clashctl/scripts/cmd/clashctl.sh"
# export TP_API_KEY="your-api-key"'
}

# ── main ────────────────────────────────────────────────────────────
main() {
  parse_args "$@"

  info "Starting dotfiles setup from $DOTFILES_DIR"
  if ((SKIP_PACKAGES)); then
    info "Skipping software package installation/update"
    require_stow
  else
    install_stow
    install_brew
    run_brew_bundle
  fi

  create_local_configs
  link_dotfiles
  link_herdr_smart_splits_backend
  ok "Done! Restart your shell or run: source ~/.zshenv"
}

main "$@"
