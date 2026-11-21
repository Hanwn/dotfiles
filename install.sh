#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES_DIR"

SKIP_PACKAGES=0

info() { printf "\033[1;34m[INFO]\033[0m %s\n" "$*"; }
ok() { printf "\033[1;32m[ OK ]\033[0m %s\n" "$*"; }
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
    --skip-packages) SKIP_PACKAGES=1 ;;
    -h | --help) usage; exit 0 ;;
    *) err "Unknown option: $1"; usage >&2; exit 2 ;;
    esac
    shift
  done
}

install_brew() {
  command -v brew >/dev/null 2>&1 && return 0

  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ "$OSTYPE" == darwin* ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
}

install_stow() {
  command -v stow >/dev/null 2>&1 && return 0

  info "Installing stow..."
  if [[ "$OSTYPE" == darwin* ]]; then
    brew install stow
  elif command -v apk >/dev/null 2>&1; then
    sudo apk add --no-cache stow
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y stow
  elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get install -y stow
  else
    err "Cannot detect package manager — install stow manually"
    exit 1
  fi
}

run_brew_bundle() {
  info "Running brew bundle..."
  brew bundle --no-upgrade --file="$DOTFILES_DIR/Brewfile"
}

create_local_configs() {
  local file

  file="$HOME/.config/git/config.local"
  if [[ ! -f "$file" ]]; then
    mkdir -p "$(dirname "$file")"
    printf '%s\n' '[user]
    name = Your Name
    email = your.email@example.com' > "$file"
    ok "Created: $file"
  fi

  file="$HOME/.config/zsh/.local.env"
  if [[ ! -f "$file" ]]; then
    mkdir -p "$(dirname "$file")"
    printf '%s\n' '# Local environment variables (not tracked by git)
# source "${XDG_DATA_HOME}/clashctl/scripts/cmd/clashctl.sh"
# export TP_API_KEY="your-api-key"' > "$file"
    ok "Created: $file"
  fi
}

link_dotfiles() {
  info "Linking dotfiles..."
  stow --restow --no-folding --adopt --target="$HOME" home
  ok "All dotfiles linked"
}

main() {
  parse_args "$@"

  if ((SKIP_PACKAGES)); then
    command -v stow >/dev/null 2>&1 || { err "stow is required when using --skip-packages"; exit 1; }
  else
    install_brew
    install_stow
    run_brew_bundle
  fi

  create_local_configs
  link_dotfiles
  ok "Done! Restart your shell or run: source ~/.zshenv"
}

main "$@"
