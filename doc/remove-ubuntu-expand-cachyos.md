# Plan: Remove Ubuntu and Expand CachyOS

## Current Disk Layout
```
nvme0n1p1 (100M EFI) → nvme0n1p2 (1T CachyOS btrfs) → nvme0n1p5 (879G Ubuntu ext4) → nvme0n1p6 (771M)
```
Partitions are contiguous - expansion is possible.

## Phase 1: Safe cleanup from running system

These operations are safe because they don't touch CachyOS.

**Run the automated script:**
```bash
sudo ./scripts/remove-ubuntu-phase1.sh
```

Or manually:

1. **Remove Ubuntu EFI boot entries**
   ```bash
   sudo efibootmgr -b 0000 -B
   sudo efibootmgr -b 0002 -B
   ```

2. **Remove Ubuntu EFI folder**
   ```bash
   sudo rm -rf /boot/efi/EFI/ubuntu
   ```

3. **Verify CachyOS is still bootable**
   ```bash
   efibootmgr  # Should show only cachyos entry
   ls /boot/efi/EFI/  # Should have cachyos folder
   ```

## Phase 2: Partition operations (REQUIRES LIVE USB)

**Why live USB?** Cannot safely resize a mounted root partition.

1. **Boot from CachyOS live USB**

2. **Copy the script to the live environment (from USB or internet)**

3. **Run the automated script:**
   ```bash
   sudo ./remove-ubuntu-phase2.sh
   ```

   Or manually:

   a. **Delete Ubuntu partitions**
      ```bash
      sudo parted /dev/nvme0n1 rm 5
      sudo parted /dev/nvme0n1 rm 6
      sudo parted /dev/nvme0n1 print   # verify
      ```

   b. **Resize CachyOS partition to fill space**
      ```bash
      sudo parted /dev/nvme0n1 resizepart 2 100%
      ```

   c. **Resize btrfs filesystem to fill partition**
      ```bash
      sudo mount /dev/nvme0n1p2 /mnt
      sudo btrfs filesystem resize max /mnt
      sudo umount /mnt
      ```

4. **Reboot into CachyOS**

## Phase 3: Verification

After reboot:
```bash
lsblk                        # Should show p2 as ~1.9TB
btrfs filesystem show        # Should show new size
df -h /                      # Should reflect new space
efibootmgr                   # Should only show cachyos
```

## Alternative: Skip expansion

If you don't want to use a live USB, you can stop after Phase 1. The Ubuntu partitions will remain but unused - you can expand later anytime.

## Risks

- Phase 1: Very low risk (only touches Ubuntu boot entries)
- Phase 2: Medium risk (partition operations) - mitigated by using live USB and having backups
