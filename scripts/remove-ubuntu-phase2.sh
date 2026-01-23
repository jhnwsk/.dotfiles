#!/bin/bash
# Phase 2: Remove Ubuntu partitions and expand CachyOS
# RUN THIS FROM A LIVE USB - NOT from the installed system!

set -e

echo "=== Remove Ubuntu Partitions and Expand CachyOS ==="
echo ""
echo "WARNING: This script must be run from a live USB, not from the installed system!"
echo "Make sure you have backups before proceeding."
echo ""

# Check if running from live environment
if mountpoint -q /home 2>/dev/null && [ -d /home/wasak ]; then
    echo "ERROR: It looks like you're running from the installed system."
    echo "Please boot from a CachyOS live USB and run this script from there."
    exit 1
fi

echo "=== Current partition layout ==="
lsblk /dev/nvme0n1
echo ""

echo "=== Partition table ==="
parted /dev/nvme0n1 print
echo ""

read -p "Proceed with removing partitions 5 and 6? (y/N) " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Aborted."
    exit 1
fi

echo ""
echo "=== Removing partition 5 (Ubuntu root) ==="
parted /dev/nvme0n1 rm 5

echo "=== Removing partition 6 ==="
parted /dev/nvme0n1 rm 6

echo ""
echo "=== New partition layout ==="
parted /dev/nvme0n1 print
echo ""

read -p "Proceed with resizing partition 2 to fill disk? (y/N) " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Aborted. Partitions deleted but not resized."
    exit 1
fi

echo ""
echo "=== Resizing partition 2 to 100% ==="
parted /dev/nvme0n1 resizepart 2 100%

echo ""
echo "=== Final partition layout ==="
parted /dev/nvme0n1 print
echo ""

echo "=== Mounting and resizing btrfs filesystem ==="
mkdir -p /mnt/cachyos
mount /dev/nvme0n1p2 /mnt/cachyos

echo "Before resize:"
btrfs filesystem show /mnt/cachyos

echo ""
echo "Resizing filesystem..."
btrfs filesystem resize max /mnt/cachyos

echo ""
echo "After resize:"
btrfs filesystem show /mnt/cachyos

umount /mnt/cachyos
rmdir /mnt/cachyos

echo ""
echo "=== Phase 2 complete! ==="
echo "Reboot into CachyOS to verify."
echo ""
echo "After reboot, verify with:"
echo "  lsblk"
echo "  btrfs filesystem show"
echo "  df -h /"
