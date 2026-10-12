# Arch Hyprland dotfiles

Portable setup for my Arch laptop desktop: Hyprland, Waybar, Mako, Kitty, Thunar, GTK, and the small app UI customizations I use. Paths use the home directory instead of the current machine's username. Review the monitor scale and app-specific steps on a new device.

## Included

- Hyprland keybinds, window rules, animations, laptop media keys, and workspace helper
- Waybar layout, styling, audio output picker/watcher, and temperature/memory tooltips
- Mako notifications, Kitty preferences, and a custom Thunar “Open Terminal Here” action
- HyprBlack GTK 3 theme and GTK settings
- A portable zsh setup for Oh My Zsh, its two plugins, NVM, and Neovim
- Firefox and Obsidian CSS snippets that hide window controls while keeping the title bar
- VS Code/Code OSS user settings, merged by the installer without removing unrelated settings
- Arch package lists and an installer that backs up files it replaces

The source wallpaper path on this laptop points to a missing image, so the broken hyprpaper config and image are not included. Add your preferred wallpaper path before starting hyprpaper on a new setup. Machine-specific Conda initialization, browser data, KeePassXC state, histories, caches, and the Thunar-generated accelerator dump are not included.

## Install on another Arch laptop

1. Install Arch Linux and Hyprland, then clone this repository into `~/arch-hyprland-dotfiles`.
2. Review `hyprland/hyprland.conf`. The monitor rule uses a portable output match and scale `1.25`; change it for the new display if needed.
3. Install the listed packages:

   ```sh
   cd ~/arch-hyprland-dotfiles
   sudo pacman -Syu
   xargs -r sudo pacman -S --needed < packages-arch.txt
   ```

   Arch supports full system upgrades; avoid refreshing package databases without upgrading the system. `packages-arch-optional.txt` lists hyprpaper if you want to configure a wallpaper.

4. Install the configs:

   ```sh
   ./install.sh
   ```

   Existing target files are copied to `~/.local/state/arch-hyprland-dotfiles/backups/` before replacement. VS Code settings are merged with existing settings.

5. Configure Oh My Zsh before running the installer if you want it to install `.zshrc`. The installer skips `.zshrc` unless Oh My Zsh and both plugins already exist:

   ```sh
   git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
   git clone https://github.com/zsh-users/zsh-autosuggestions \
     ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
     ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
   ```

6. Enable the network and Bluetooth services if needed:

   ```sh
   sudo systemctl enable --now NetworkManager.service bluetooth.service
   ```

7. Log out and back into Hyprland. Mako can be reloaded separately with `makoctl reload`.

## App-specific CSS

These are UI customizations; the installer leaves each app's profile or vault untouched.

- **Firefox:** open `about:profiles`, open the active profile directory, and create a `chrome` folder if needed. Copy `firefox/userChrome.css` into that folder. Add the preference from `firefox/user.js` to the profile's existing `user.js` (or copy the file if no `user.js` exists). Restart Firefox. The preference enables custom stylesheets.
- **Obsidian:** copy `obsidian/hide-window-controls.css` to the vault's `.obsidian/snippets/` folder, then enable it under **Settings → Appearance → CSS snippets**. Enable it separately in each vault.
- **VS Code / Code OSS:** `install.sh` merges `vscode/settings.json` into the Code OSS settings file. Restart the editor to apply the custom title bar and hidden controls.

## Keybinds

| Key | Action |
| --- | --- |
| Super+T | Kitty terminal |
| Super+E | Thunar file manager |
| Super+M | Audio output picker |
| Super+N | Network connections |
| Super+B | Bluetooth manager |
| Super+F | Firefox |
| Super+C | Code |
| Super+O | Obsidian AppImage at `~/.local/bin/obsidian.AppImage` |
| Super+K | KeePassXC |
| Super+Q | Close focused window |
| Super+Esc | Exit Hyprland |
| Super+S | Select and copy a screenshot |
| Super+Arrow keys | Focus a window in that direction |
| Super+1…0 | Switch to workspaces 1…10 |
| Ctrl+Super+1…0 | Move the focused window to workspaces 1…10 |

Media, volume, and brightness keys use PipeWire, Playerctl, and BrightnessCtl.

## Device-specific notes

- The monitor rule uses a 1.25 scale. Adjust it for high-DPI or external displays.
- The temperature tooltip recognizes Intel `coretemp` and NVMe sensors. Other hardware may show “unavailable” until its sensor names are added.
- The audio watcher selects newly connected wired headphones or Bluetooth audio devices. Remove its Hyprland `exec-once` line if you prefer to select outputs manually.
- Super+O expects an Obsidian AppImage at `~/.local/bin/obsidian.AppImage`; the AppImage itself is not included.
- Hyprpaper is optional and is not started automatically because the current wallpaper image is missing.
- Super+C and Super+K expect the `code` and `keepassxc` commands to be installed.

## Push to GitHub

Review the files before publishing. Keep this repository private if you don't want to publish your personal desktop preferences. From this directory:

```sh
git init -b main
git add .
git diff --cached --check
git diff --cached
git commit -m "Add Arch Hyprland dotfiles"
git remote add origin git@github.com:YOUR_USERNAME/arch-hyprland-dotfiles.git
git push -u origin main
```

Replace `YOUR_USERNAME` with your GitHub username. Run Git commands only inside this dedicated folder, never from the whole home directory.
