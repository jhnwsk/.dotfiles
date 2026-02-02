# .dotfiles

![screenshot](screenshot.png)

> hyprland + waybar + matugen + zsh + starship + tmux + astronvim

---

Personal dotfiles for Arch Linux with Hyprland. Tested on CachyOS. Wallpaper-based theming via matugen.

## Prerequisites

```bash
sudo pacman -S git dialog paru
```

`yay` can be used instead of `paru` if preferred.

## Quick Start

```bash
git clone git@github.com:jhnwsk/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./setup.sh
```

Interactive menu lets you pick what to install. Or `./setup.sh --all` for everything.

## What's Inside

- **Shell**: zsh + antigen + starship + nerd fonts
- **Editor**: neovim (AstroNvim) + vim
- **Terminal**: kitty + tmux
- **Desktop**: hyprland + waybar + wofi + dunst + wlogout + kanshi
- **Theming**: matugen (wallpaper-based colors for waybar, wofi, dunst, hyprland)
- **Dev**: rust, python, nodejs, docker

## Monitor Setup

Display profiles are managed by kanshi. On first setup, the config is copied (not symlinked) since monitor identifiers are machine-specific.

To configure for your monitors:

```bash
kanshi-setup                  # Detect monitors and get profile suggestions
vim ~/.config/kanshi/config   # Edit with suggested profiles
```

## Theming

Change your wallpaper and regenerate all colors:

```bash
matugen image ~/path/to/wallpaper.jpg
```

This updates waybar, wofi, dunst, and hyprland colors to match.
