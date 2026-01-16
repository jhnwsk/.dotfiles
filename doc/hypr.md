# Hyprland Cheat Sheet

## Troubleshooting

### HyprPanel Frozen

HyprPanel runs via `gjs`, not as its own process. To refresh:

```bash
pkill -9 gjs && hyprpanel &
```

Or the full command:

```bash
kill -9 $(pgrep -f gjs) && sleep 0.5 && hyprpanel &
```

## Useful Commands

| Command | Action |
|---------|--------|
| `hyprctl reload` | Reload Hyprland config |
| `hyprctl clients` | List all windows |
| `hyprctl activewindow` | Show focused window info |
| `hyprctl monitors` | List monitors |
| `hyprctl workspaces` | List workspaces |
| `hyprctl kill` | Kill mode (click to kill window) |

## Config Reload

```bash
hyprctl reload          # Reload hyprland.conf
pkill -9 gjs && hyprpanel &  # Restart HyprPanel
```
