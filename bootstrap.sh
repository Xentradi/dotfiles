#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

say() { printf "\033[1;36m%s\033[0m\n" "$*"; }
warn() { printf "\033[1;33m%s\033[0m\n" "$*"; }
err() { printf "\033[1;31m%s\033[0m\n" "$*"; }

need() {
  command -v "$1" >/dev/null 2>&1 || { err "Missing required command: $1"; exit 1; }
}

need ln
need mkdir
need rm

mkdir -p "$HOME/.config"

backup_if_exists() {
  local dst="$1"
  if [ -L "$dst" ] || [ -e "$dst" ]; then
    mkdir -p "$BACKUP_DIR"
    warn "Backing up existing: $dst -> $BACKUP_DIR"
    mv "$dst" "$BACKUP_DIR"/
  fi
}

link() {
  local src="$1"
  local dst="$2"

  if [ ! -e "$src" ] && [ ! -L "$src" ]; then
    warn "Skip (missing in repo): $src"
    return 0
  fi

  backup_if_exists "$dst"
  ln -s "$src" "$dst"
  say "Linked: $dst -> $src"
}

say "Using dotfiles at: $DOTFILES_DIR"
[ -d "$DOTFILES_DIR" ] || { err "Dotfiles directory not found: $DOTFILES_DIR"; exit 1; }

# Home dotfiles
link "$DOTFILES_DIR/home/.zshrc" "$HOME/.zshrc"
link "$DOTFILES_DIR/home/.zsh_aliases" "$HOME/.zsh_aliases"
link "$DOTFILES_DIR/home/.fzf.zsh" "$HOME/.fzf.zsh"

# ~/.config
link "$DOTFILES_DIR/config/starship.toml" "$HOME/.config/starship.toml"
link "$DOTFILES_DIR/config/ghostty" "$HOME/.config/ghostty"
link "$DOTFILES_DIR/config/nano" "$HOME/.config/nano"

say "Done."
if [ -d "$BACKUP_DIR" ]; then
  warn "Backups stored in: $BACKUP_DIR"
fi

say "Next:"
say "  1) exec zsh"
say "  2) brew bundle --file=$DOTFILES_DIR/Brewfile (after Homebrew is installed)"
