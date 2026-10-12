#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
timestamp="$(date +%Y%m%d-%H%M%S)"
backup_root="${XDG_STATE_HOME:-$HOME/.local/state}/arch-hyprland-dotfiles/backups/$timestamp"
made_backup=false

install_file() {
  local source="$1"
  local target_rel="$2"
  local mode="$3"
  local target="$HOME/$target_rel"

  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$backup_root/$(dirname -- "$target_rel")"
    cp -a -- "$target" "$backup_root/$target_rel"
    made_backup=true
  fi

  install -D -m "$mode" -- "$repo_dir/$source" "$target"
}

install_file hyprland/hyprland.conf .config/hypr/hyprland.conf 644
install_file hyprland/compact-workspaces.py .config/hypr/compact-workspaces.py 755
install_file waybar/config .config/waybar/config 644
install_file waybar/style.css .config/waybar/style.css 644

for script in \
  audio-device-watcher \
  audio-menu \
  audio-volume-up \
  audio-volume-down \
  memory-tooltip \
  temperature-tooltip; do
  install_file "waybar/$script" ".config/waybar/$script" 755
done

install_file mako/config .config/mako/config 644
install_file kitty/kitty.conf .config/kitty/kitty.conf 644
install_file thunar/uca.xml .config/Thunar/uca.xml 644
install_file gtk/settings.ini .config/gtk-3.0/settings.ini 644
install_file gtk/HyprBlack/gtk-3.0/gtk.css .local/share/themes/HyprBlack/gtk-3.0/gtk.css 644

if [[ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" \
  && -f "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  && -f "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  install_file shell/zshrc .zshrc 644
else
  printf 'Skipping .zshrc: install Oh My Zsh and its autosuggestions/syntax-highlighting plugins first.\n'
fi

# Merge the portable settings so unrelated user settings are preserved. Use the
# settings directory that already exists, and default to the Arch Code OSS path.
if [[ -d "$HOME/.config/Code/User" ]]; then
  vscode_settings="$HOME/.config/Code/User/settings.json"
  vscode_settings_rel=".config/Code/User/settings.json"
else
  vscode_settings="$HOME/.config/Code - OSS/User/settings.json"
  vscode_settings_rel=".config/Code - OSS/User/settings.json"
fi
if [[ -e "$vscode_settings" || -L "$vscode_settings" ]]; then
  mkdir -p "$backup_root/$(dirname -- "$vscode_settings_rel")"
  cp -a -- "$vscode_settings" "$backup_root/$vscode_settings_rel"
  made_backup=true
fi
mkdir -p "$(dirname -- "$vscode_settings")"
python3 - "$repo_dir/vscode/settings.json" "$vscode_settings" <<'PY'
import json
import pathlib
import sys

source, destination = map(pathlib.Path, sys.argv[1:])
settings = json.loads(destination.read_text()) if destination.exists() else {}
settings.update(json.loads(source.read_text()))
destination.write_text(json.dumps(settings, indent=4, ensure_ascii=False) + "\n")
PY

if [[ "$made_backup" == true ]]; then
  printf 'Previous files were backed up under: %s\n' "$backup_root"
fi
printf 'Dotfiles installed. Review the monitor scale in ~/.config/hypr/hyprland.conf, then reload Hyprland.\n'
