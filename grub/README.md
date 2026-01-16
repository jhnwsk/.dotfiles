# GRUB Dual-Boot Configuration

## Problem
Ubuntu's GRUB doesn't show CachyOS/Arch entries.

## Cause
Ubuntu defaults to `GRUB_DISABLE_OS_PROBER=true` for security, which prevents detecting other operating systems.

## Fix (on Ubuntu)

1. Install os-prober:
   ```bash
   sudo apt install os-prober
   ```

2. Edit GRUB config:
   ```bash
   sudo nano /etc/default/grub
   ```

3. Add or change this line:
   ```
   GRUB_DISABLE_OS_PROBER=false
   ```

4. Regenerate GRUB:
   ```bash
   sudo update-grub
   ```

## Key Differences

| Setting | CachyOS | Ubuntu Default |
|---------|---------|----------------|
| `GRUB_DISABLE_OS_PROBER` | `false` | `true` |
| `GRUB_TIMEOUT` | `5` | `0` (often hidden) |
| `GRUB_TIMEOUT_STYLE` | `menu` | `hidden` |

## Files in this directory

- `cachy-default-grub` - CachyOS's `/etc/default/grub` for reference
- `cachy-grub.cfg` - Full generated GRUB config (if dumped with sudo)
