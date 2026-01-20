# Switching from GRUB to systemd-boot on CachyOS

A guide for migrating from GRUB to systemd-boot on an existing CachyOS (or Arch) installation.

## Prerequisites

- UEFI system (not legacy BIOS)
- EFI System Partition (ESP) mounted at `/boot` or `/efi`

## Step 1: Verify UEFI Mode

```bash
ls /sys/firmware/efi
```

If this directory exists, you're on UEFI and can proceed.

## Step 2: Check Your Current Setup

```bash
# Find your root partition UUID
blkid | grep -i root

# Check your kernel name (CachyOS uses custom kernels)
ls /boot/vmlinuz*

# Check your initramfs name
ls /boot/initramfs*.img
```

## Step 3: Install systemd-boot

```bash
sudo bootctl install
```

This installs the bootloader to your EFI partition.

## Step 4: Create Boot Entry

```bash
sudo nano /boot/loader/entries/cachyos.conf
```

Content (adjust kernel/initramfs names and UUID to match your system):

```ini
title   CachyOS
linux   /vmlinuz-linux-cachyos
initrd  /initramfs-linux-cachyos.img
options root=UUID=YOUR-ROOT-UUID-HERE rw quiet
```

If you have an Intel/AMD CPU microcode package installed, add it before the main initramfs:

```ini
title   CachyOS
linux   /vmlinuz-linux-cachyos
initrd  /amd-ucode.img
initrd  /initramfs-linux-cachyos.img
options root=UUID=YOUR-ROOT-UUID-HERE rw quiet
```

## Step 5: Configure Loader

```bash
sudo nano /boot/loader/loader.conf
```

Content:

```ini
default cachyos.conf
timeout 3
console-mode max
editor  no
```

Setting `editor no` prevents boot parameter editing at boot (security).

## Step 6: Verify Configuration

```bash
# Check bootctl status
sudo bootctl status

# List entries
sudo bootctl list
```

## Step 7: Reboot and Test

```bash
sudo reboot
```

**Important**: Make sure the system boots successfully before removing GRUB!

## Step 8: Remove GRUB (after confirming boot works)

```bash
# Remove GRUB packages
sudo pacman -Rns grub os-prober

# Remove GRUB files from /boot
sudo rm -rf /boot/grub

# Optional: remove GRUB EFI entry
sudo efibootmgr  # list entries
sudo efibootmgr -b XXXX -B  # delete old GRUB entry (replace XXXX with entry number)
```

## Troubleshooting

### System won't boot

Boot from a live USB and:

```bash
# Mount your partitions
mount /dev/sdX2 /mnt          # root partition
mount /dev/sdX1 /mnt/boot     # EFI partition

# Chroot in
arch-chroot /mnt

# Reinstall GRUB as fallback
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

### Finding kernel parameters

Check what GRUB was using:

```bash
cat /proc/cmdline
```

Use these same options in your systemd-boot entry.

## Fallback Entry (optional but recommended)

Create a fallback entry using the fallback initramfs:

```bash
sudo nano /boot/loader/entries/cachyos-fallback.conf
```

```ini
title   CachyOS (fallback)
linux   /vmlinuz-linux-cachyos
initrd  /initramfs-linux-cachyos-fallback.img
options root=UUID=YOUR-ROOT-UUID-HERE rw quiet
```

## Why systemd-boot?

- Faster boot times
- Simpler configuration
- Already part of systemd (no extra packages)
- Easy to maintain
- Auto-updates with `bootctl update`
