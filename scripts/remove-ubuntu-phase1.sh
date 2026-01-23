#!/bin/bash
# Phase 1: Remove Ubuntu EFI entries and folder
# Safe to run from running CachyOS system

set -e

echo "=== Current EFI boot entries ==="
efibootmgr

echo ""
echo "=== Current EFI folder contents ==="
ls -la /boot/efi/EFI/

echo ""
read -p "Proceed with removing Ubuntu entries? (y/N) " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Aborted."
    exit 1
fi

echo ""
echo "=== Removing Ubuntu boot entries ==="

# Remove Boot0000 (UEFI RST Ubuntu auto-created)
if efibootmgr | grep -q "Boot0000"; then
    echo "Removing Boot0000..."
    efibootmgr -b 0000 -B
fi

# Remove Boot0002 (Ubuntu)
if efibootmgr | grep -q "Boot0002"; then
    echo "Removing Boot0002..."
    efibootmgr -b 0002 -B
fi

echo ""
echo "=== Removing Ubuntu EFI folder ==="
if [ -d /boot/efi/EFI/ubuntu ]; then
    echo "Removing /boot/efi/EFI/ubuntu..."
    rm -rf /boot/efi/EFI/ubuntu
fi

if [ -d /boot/efi/EFI/Ubuntu ]; then
    echo "Removing /boot/efi/EFI/Ubuntu..."
    rm -rf /boot/efi/EFI/Ubuntu
fi

echo ""
echo "=== Verification ==="
echo "EFI boot entries:"
efibootmgr

echo ""
echo "EFI folder contents:"
ls -la /boot/efi/EFI/

echo ""
echo "Phase 1 complete! Ubuntu boot entries removed."
echo ""
echo "Next steps (Phase 2 - requires live USB boot):"
echo "  1. Boot from CachyOS live USB"
echo "  2. Run: sudo parted /dev/nvme0n1 rm 5"
echo "  3. Run: sudo parted /dev/nvme0n1 rm 6"
echo "  4. Run: sudo parted /dev/nvme0n1 resizepart 2 100%"
echo "  5. Mount and resize btrfs:"
echo "     sudo mount /dev/nvme0n1p2 /mnt"
echo "     sudo btrfs filesystem resize max /mnt"
echo "     sudo umount /mnt"
echo "  6. Reboot into CachyOS"
