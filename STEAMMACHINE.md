# SteamMachine Setup

Turn a CachyOS install into a console-like SteamMachine that boots directly into Steam Big Picture via gamescope.

## Getting Started

Fresh CachyOS install without network? Connect via TTY:

```bash
# Press Ctrl+Alt+F2 for a terminal, then:
nmtui                        # Connect to WiFi (interactive)
git clone <your-repo>
cd <repo>
./setup_gaming.sh
```

Or use ethernet (works automatically) or copy the repo via USB.

## Quick Start

```bash
./setup_gaming.sh
```

The script automatically installs everything needed, then asks if you want the optional Hyprland fallback desktop.

### Unattended Install

```bash
./setup_gaming.sh --with-fallback   # Include Hyprland desktop
./setup_gaming.sh --no-fallback     # Steam-only, no desktop
```

## What Gets Installed

| Step | Description |
|------|-------------|
| base | Audio (pipewire) + essentials |
| gpu | Auto-detect and install GPU drivers |
| gaming | Steam, gamescope, Proton, Wine via CachyOS packages |
| greetd | Auto-login directly into gamescope-session |
| fallback | *(optional)* Hyprland desktop for non-gaming tasks |

### CachyOS Packages

The script uses CachyOS meta-packages which bundle everything needed:

| Package | Contents |
|---------|----------|
| `cachyos-gaming-meta` | Proton, Wine, 32-bit libs, Vulkan tools, audio plugins |
| `cachyos-gaming-applications` | Steam, gamescope, mangohud, gamemode |
| `cachyos-handheld` | Gamescope-session (Steam Deck-like boot) |

### GPU Detection

Automatically detects your GPU and installs appropriate drivers:

- **NVIDIA**: `nvidia nvidia-utils lib32-nvidia-utils`
- **AMD**: `mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon`
- **Intel**: `mesa lib32-mesa vulkan-intel lib32-vulkan-intel`

## Boot Flow

1. System boots
2. greetd starts `gamescope-session-steam` as configured user
3. Steam Big Picture launches in gamescope compositor
4. Controller navigation works out of the box

## Post-Install

After rebooting, you should land directly in Steam Big Picture mode. Use a controller to navigate.

**WiFi**: Configure in Steam > Settings > Internet. NetworkManager is installed by the base section.

To exit to a terminal: press `Ctrl+Alt+F2` for a TTY.

If you installed the fallback desktop, edit `/etc/greetd/config.toml` to switch between sessions.

## References

- [CachyOS Gaming Guide](https://wiki.cachyos.org/configuration/gaming/)
- [CachyOS Handheld](https://github.com/CachyOS/CachyOS-Handheld)
