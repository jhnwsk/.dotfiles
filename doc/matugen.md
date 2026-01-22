# Matugen - Material You Color Generator

Generates color themes from wallpapers for waybar, hyprland, wofi, and more.

## Usage

```bash
# Generate colors from wallpaper (uses config.toml defaults)
matugen image /path/to/wallpaper.jpg

# Show generated color palette
matugen image /path/to/wallpaper.jpg --show-colors
```

## Config

Location: `~/.config/matugen/config.toml`

```toml
[config]
scheme = "scheme-tonal-spot"  # Color scheme type
contrast = 0.0                 # -1.0 to 1.0
```

## Schemes

| Scheme | Description |
|--------|-------------|
| `scheme-tonal-spot` | Default Material You, balanced |
| `scheme-content` | Colors directly from image |
| `scheme-expressive` | More vibrant/playful |
| `scheme-fidelity` | Stays close to source colors |
| `scheme-monochrome` | Single hue, grayscale feel |
| `scheme-neutral` | Muted, desaturated |
| `scheme-rainbow` | Full spectrum |
| `scheme-fruit-salad` | Colorful, mixed |

## CLI Overrides

```bash
# Override scheme
matugen image wallpaper.jpg -t scheme-expressive

# Force light/dark mode
matugen image wallpaper.jpg -m dark
matugen image wallpaper.jpg -m light

# Adjust contrast (-1.0 to 1.0)
matugen image wallpaper.jpg --contrast 0.5
```

## Templates

One `matugen image` command generates all configured templates:

| Template | Output |
|----------|--------|
| waybar-colors | `~/.config/waybar/colors.css` |
| hyprland-colors | `~/.config/hypr/conf/colors.conf` |
| hyprtoolkit | `~/.config/hypr/hyprtoolkit.conf` |
| wofi-style | `~/.config/wofi/style.css` |

## Hyprpanel Integration

Hyprpanel has a UI for changing theme/scheme/variation - it calls matugen with different options under the hood.
