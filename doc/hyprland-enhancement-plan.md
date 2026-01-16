# Plan: Hyprland Configuration Enhancement (Cherry-pick from ML4W)

## Goal
Enhance your Hyprland setup by adopting select ML4W components while preserving your existing dotfiles (nvim, tmux, starship, multi-distro support).

## Components to Add
1. **Modular hyprland.conf** - Split into organized files
2. **Waybar configuration** - Status bar with theming
3. **matugen** - Adaptive colors from wallpaper
4. **wlogout** - Graphical logout menu

---

## Implementation Steps

### 1. Restructure Hyprland Config (Modular)

Split `.config/hypr/hyprland.conf` (356 lines) into:

```
.config/hypr/
├── hyprland.conf          # Main entry (sources other files)
├── conf/
│   ├── monitor.conf       # Monitor settings
│   ├── programs.conf      # $terminal, $fileManager, $menu vars
│   ├── autostart.conf     # exec-once statements
│   ├── environment.conf   # env variables
│   ├── general.conf       # gaps, borders, layout
│   ├── decoration.conf    # rounding, shadows, blur
│   ├── animation.conf     # beziers and animations
│   ├── input.conf         # keyboard, mouse, touchpad
│   ├── keybinding.conf    # all keybinds
│   ├── windowrule.conf    # window rules
│   └── custom.conf        # user overrides (empty, for local tweaks)
├── hypridle.conf          # (existing)
└── hyprlock.conf          # (existing)
```

Main `hyprland.conf` becomes:
```conf
source = ~/.config/hypr/conf/monitor.conf
source = ~/.config/hypr/conf/programs.conf
source = ~/.config/hypr/conf/autostart.conf
source = ~/.config/hypr/conf/environment.conf
source = ~/.config/hypr/conf/general.conf
source = ~/.config/hypr/conf/decoration.conf
source = ~/.config/hypr/conf/animation.conf
source = ~/.config/hypr/conf/input.conf
source = ~/.config/hypr/conf/keybinding.conf
source = ~/.config/hypr/conf/windowrule.conf
source = ~/.config/hypr/conf/custom.conf
```

### 2. Add Waybar Configuration

Create `.config/waybar/`:
```
.config/waybar/
├── config.jsonc           # Modules and layout
├── style.css              # Base styling
└── colors.css             # Color variables (updated by matugen)
```

**Key modules to include:**
- Workspaces (clickable)
- Window title
- System tray
- Clock/calendar
- Network status
- Audio volume
- Battery (if laptop)
- CPU/memory usage

**Update setup.sh:** Uncomment waybar symlink (line 224)

### 3. Add matugen for Adaptive Theming

Create `.config/matugen/`:
```
.config/matugen/
├── config.toml            # Main config
└── templates/
    ├── hyprland-colors.conf
    ├── waybar-colors.css
    └── hyprlock-colors.conf
```

**How it works:**
- Run `matugen <wallpaper.jpg>`
- Extracts dominant colors using Material Design algorithm
- Generates config files from templates
- Waybar/Hyprland reload to apply new colors

**Add to setup.sh:** `aur_install matugen-bin`

### 4. Add wlogout Menu

Create `.config/wlogout/`:
```
.config/wlogout/
├── layout                 # Button definitions
├── style.css              # Visual styling
└── icons/                 # Custom icons (optional)
```

**Layout options:**
- Lock
- Logout
- Suspend
- Hibernate
- Reboot
- Shutdown

**Add keybinding:** `bind = $mainMod, M, exec, wlogout`

**Add to setup.sh:** `pkg_install wlogout` (Arch) or `aur_install wlogout`

---

## Files to Create/Modify

### New Files
| File | Purpose |
|------|---------|
| `.config/hypr/conf/monitor.conf` | Monitor config |
| `.config/hypr/conf/programs.conf` | Program variables |
| `.config/hypr/conf/autostart.conf` | Autostart commands |
| `.config/hypr/conf/environment.conf` | Environment vars |
| `.config/hypr/conf/general.conf` | General settings |
| `.config/hypr/conf/decoration.conf` | Window decoration |
| `.config/hypr/conf/animation.conf` | Animations |
| `.config/hypr/conf/input.conf` | Input devices |
| `.config/hypr/conf/keybinding.conf` | Keybindings |
| `.config/hypr/conf/windowrule.conf` | Window rules |
| `.config/hypr/conf/custom.conf` | Custom overrides |
| `.config/waybar/config.jsonc` | Waybar config |
| `.config/waybar/style.css` | Waybar styling |
| `.config/waybar/colors.css` | Color variables |
| `.config/matugen/config.toml` | Matugen config |
| `.config/matugen/templates/*` | Color templates |
| `.config/wlogout/layout` | Logout buttons |
| `.config/wlogout/style.css` | Logout styling |

### Modified Files
| File | Changes |
|------|---------|
| `.config/hypr/hyprland.conf` | Replace contents with source statements |
| `setup.sh` | Add matugen, wlogout; uncomment waybar symlink |

---

## setup.sh Updates

```bash
function run_hyprland {
    # ... existing code ...
    case "$DISTRO" in
        arch)
            pkg_install waybar wofi dunst swww wl_clipboard grim slurp wlogout
            aur_install matugen-bin
            ;;
        *)
            echo "Hyprland tools not configured for $DISTRO"
            ;;
    esac
    ln -sfn "$(pwd)/.config/hypr" "$HOME/.config/hypr"
    ln -sfn "$(pwd)/.config/waybar" "$HOME/.config/waybar"
    ln -sfn "$(pwd)/.config/wlogout" "$HOME/.config/wlogout"
    ln -sfn "$(pwd)/.config/matugen" "$HOME/.config/matugen"
    # ... rest ...
}
```

---

## Verification

1. **Test modular config:**
   ```bash
   hyprctl reload
   # Should load without errors
   ```

2. **Test Waybar:**
   ```bash
   killall waybar; waybar &
   # Bar should appear with modules
   ```

3. **Test matugen:**
   ```bash
   matugen ~/wallpapers/sample.jpg
   # Should generate color configs
   hyprctl reload && killall waybar && waybar &
   # Colors should update
   ```

4. **Test wlogout:**
   ```bash
   wlogout
   # Should show graphical menu
   # Press Super+M as keybind test
   ```

---

## Order of Implementation

1. Create modular hyprland config structure (conf/ directory)
2. Split existing hyprland.conf into modules
3. Test hyprland loads correctly
4. Create Waybar configuration
5. Add Waybar to autostart
6. Create wlogout configuration
7. Add wlogout keybinding
8. Set up matugen with templates
9. Update setup.sh with new packages and symlinks
10. Test full workflow end-to-end

---

## Reference
Based on: https://github.com/mylinuxforwork/dotfiles (ML4W)
