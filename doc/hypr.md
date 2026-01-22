# Hyprland Cheat Sheet

## Monitor Configuration

The monitor config (`.config/hypr/conf/monitor.conf`) uses **description-based matching** instead of port names. This makes it location-aware - works automatically at work or home regardless of which dock port monitors are connected to.

### How It Works

```hypr
# Match by description (model name) instead of port (DP-5, DP-7)
monitor=desc:DELL P2719H,1920x1080@60,auto,1
```

Hyprland's `desc:` matcher identifies monitors by their description string (visible via `hyprctl monitors`). The `auto` position arranges all monitors in a horizontal row.

**Layout behavior:** Internal display (laptop) is positioned first at 0x0, external monitors follow to the right.

### Current Setups

| Location | Monitors | Layout |
|----------|----------|--------|
| Work | P2719H + P2722HE + Laptop | Laptop → P2719H → P2722HE |
| Home | S2721DGF + Laptop | Laptop → S2721DGF |

### Useful Commands

```bash
hyprctl monitors          # Show connected monitors with descriptions
hyprctl monitors -j       # JSON output for scripting
hyprctl reload            # Apply config changes
```

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
