# Gaming on CachyOS/Arch

## Installed Packages

- **cachyos-gaming-meta**: Proton, Wine, codecs, Vulkan tools, 32-bit libraries
- **cachyos-gaming-applications**: Steam, Lutris, Heroic, MangoHud, Gamescope, Goverlay

## Proton Versions

| Version | Use Case |
|---------|----------|
| `proton-cachyos` | General gaming, FSR, Wine-staging patches |
| `proton-cachyos-slr` | Anti-cheat games (EAC, BattlEye) |

## Environment Variables for Games

```bash
PROTON_DLSS_UPGRADE=1        # Auto-upgrade DLSS
PROTON_FSR4_UPGRADE=1        # Auto-upgrade FSR
PROTON_NVIDIA_LIBS_NO_32BIT=1  # Fix RTX 4000+ performance
PROTON_ENABLE_WAYLAND=1      # Native Wayland support
PROTON_USE_NTSYNC=1          # NTSync synchronization
```

## System Configuration

### NVIDIA Shader Cache
Set in `/etc/environment`:
```
__GL_SHADER_DISK_CACHE_SIZE=12000000000
```

### Performance Management
Using **ananicy-cpp** (CachyOS default) - do NOT install gamemode, they conflict.

## Steam Settings

### Hyprland Fix (Black Rectangle)
Steam shows a black window on Hyprland. Fix by launching with:
```bash
steam -no-cef-sandbox
```

A patched desktop entry is at `~/.local/share/applications/steam.desktop`.

### Downloads Settings
In Steam > Settings > Downloads:
- Uncheck "Allow background processing of Vulkan shaders"
- Uncheck "Enable Shader Pre-caching"

Set default Proton to `proton-cachyos-slr` for best compatibility.

## Launch Options

### Dota 2 (Native Linux)
```
prime-run %command%
```

### Dota 2 with Proton + Wayland
```
PROTON_ENABLE_WAYLAND=1 prime-run %command%
```

### With MangoHud overlay
```
mangohud prime-run %command%
```

### Full optimization example
```
PROTON_ENABLE_WAYLAND=1 PROTON_USE_NTSYNC=1 mangohud prime-run %command%
```

## Verification

1. Launch Steam: `steam`
2. Check GPU usage during game: `nvidia-smi`
3. MangoHud shows FPS, GPU/CPU stats in-game

## Useful Tools

- **MangoHud**: In-game performance overlay
- **Gamescope**: Micro-compositor for games (scaling, FSR)
- **Goverlay**: GUI to configure MangoHud
- **protontricks**: Install Windows dependencies in Proton prefixes
- **umu-launcher**: Run games with Proton outside Steam
