# Screen Sharing on Hyprland

Guide for getting screen sharing working on Hyprland (for Discord, OBS, etc.)

Source: https://gist.github.com/brunoanc/2dea6ddf6974ba4e5d26c3139ffb7580

## Install Dependencies

```bash
sudo pacman -S pipewire wireplumber grim slurp
yay -S xdg-desktop-portal-hyprland-git
```

## Configure Hyprland

Add to `~/.config/hypr/hyprland.conf`:

```
exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
```

## Verify Services

```bash
systemctl --user status pipewire wireplumber
systemctl --user status xdg-desktop-portal-hyprland
```

## Troubleshooting

### Remove conflicting portals
```bash
pacman -Q | grep xdg-desktop-portal-
# Remove any conflicting ones (gtk, wlr, etc.) if having issues
```

### Check for conflicting config
Remove or edit `~/.config/xdg-desktop-portal/portals.conf` if it exists from a previous DE.

### Intel iGPU issues
Remove `bitdepth,10` from monitor rules if screen sharing shows black screen.

### NVIDIA
Use `hyprland-nvidia-git` package or check gist for wlroots patches.

## Testing

1. Log out and back in after setup
2. OBS: Use "Screen Capture (PipeWire)"
3. Discord/browsers: Should work with PipeWire portal

## Status

Working as of 2026-01-23.
