# PLACEHOLDER so the flake evaluates before the machine exists.
# At install time replace with the real output of:
#   nixos-generate-config --root /mnt
# The by-label device below only matches if the root partition is labeled
# "nixos" during partitioning (mkfs.ext4 -L nixos / mkfs.fat -n BOOT).
{ ... }:
{
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };
}
