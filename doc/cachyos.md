# CachyOS Notes

Tips, fixes, and learnings from running CachyOS (Arch-based).

## Audio / PipeWire

### Bluetooth Audio Not Playing (But Shows Connected)

**Symptom**: Bluetooth device shows as connected and selected in audio panel, but no sound comes through.

**Cause**: PipeWire routes audio per-stream. If an app started playing before Bluetooth connected (or was explicitly routed to another device), that stream stays on the old device even after you change the default.

**Fix**: Move existing streams to the default sink:

```bash
# Move all streams to default sink
pactl list sink-inputs short | while read -r id rest; do
    pactl move-sink-input "$id" @DEFAULT_SINK@
done
```

Or use the `audio-to-default` script in `.local/bin/`.

**GUI Alternative**: Use `pwvucontrol` or `pavucontrol` to drag streams to the correct output.

### Understanding PipeWire Routing

- **Default sink**: Where NEW streams go
- **Existing streams**: Stay on their current device unless moved
- `follow-default-target` setting exists but only applies to streams using "default" - explicitly routed streams won't follow

### Useful Commands

```bash
# Check what's playing where
pactl list sink-inputs short

# See all sinks and their status
pactl list sinks short

# Show detailed audio routing
wpctl status

# Move specific stream (get ID from sink-inputs)
pactl move-sink-input <stream-id> @DEFAULT_SINK@

# Set default sink by name
pactl set-default-sink <sink-name>
```

### Bluetooth Audio Profiles

Bluetooth audio has two main profiles:
- **A2DP**: High quality stereo (music/media) - no microphone
- **HSP/HFP**: Lower quality mono with microphone (calls)

Switch profiles in `pwvucontrol` or:
```bash
pactl set-card-profile <card-name> a2dp-sink
```

## Packages

### Audio Stack
- `pipewire` - Modern audio server
- `wireplumber` - Session manager for PipeWire
- `pwvucontrol` - GTK4 PipeWire volume control (recommended)
- `pavucontrol` - Classic PulseAudio volume control (also works with PipeWire)

### Bluetooth
- `bluez` - Bluetooth stack
- `bluez-utils` - CLI tools (`bluetoothctl`)

## See Also

- [grub-to-systemd-boot.md](grub-to-systemd-boot.md) - Switching bootloaders
- [hypr.md](hypr.md) - Hyprland notes
