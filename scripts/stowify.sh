#!/usr/bin/env bash

set -Ee -o pipefail

command -v stow >/dev/null 2>&1 || { echo "Error: GNU Stow is not installed." >&2; exit 1; }

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd "$script_dir/.." && pwd)"
backup_dir="$repo_dir/.backup/$(date -u +%Y%m%d-%H%M%S)"

mkdir -p "$backup_dir"

mkdir -p \
  "$repo_dir/dotfiles/alacritty/.config" \
  "$repo_dir/dotfiles/bash" \
  "$repo_dir/dotfiles/git/.config" \
  "$repo_dir/dotfiles/tmux/.config" \
  "$repo_dir/dotfiles/mise/.config" \
  "$repo_dir/dotfiles/gh/.config"

backup_and_move() {
  local source_path="$1"
  local destination_path="$2"

  if [ -e "$source_path" ] && [ ! -L "$source_path" ]; then
    mkdir -p "$(dirname "$destination_path")"
    local base_name
    base_name="$(basename "$source_path")"
    cp -a "$source_path" "$backup_dir/$base_name"
    mv "$source_path" "$destination_path"
  fi
}

# Home-level dotfiles
backup_and_move "$HOME/.gitconfig" "$repo_dir/dotfiles/git/.gitconfig"
backup_and_move "$HOME/.bashrc"    "$repo_dir/dotfiles/bash/.bashrc"
backup_and_move "$HOME/.profile"   "$repo_dir/dotfiles/bash/.profile"

# ~/.config directories
backup_and_move "$HOME/.config/alacritty" "$repo_dir/dotfiles/alacritty/.config/alacritty"
backup_and_move "$HOME/.config/git"  "$repo_dir/dotfiles/git/.config/git"
backup_and_move "$HOME/.config/tmux" "$repo_dir/dotfiles/tmux/.config/tmux"
backup_and_move "$HOME/.config/mise" "$repo_dir/dotfiles/mise/.config/mise"
backup_and_move "$HOME/.config/gh"   "$repo_dir/dotfiles/gh/.config/gh"

echo "Backed up originals to: $backup_dir"

cd "$repo_dir/dotfiles"
stow -v -R -t "$HOME" alacritty bash git tmux mise gh

echo "Stow completed."

