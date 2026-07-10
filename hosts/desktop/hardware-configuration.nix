# PLACEHOLDER — no hardware exists yet. Present only so
# `nix eval .#nixosConfigurations.desktop...toplevel.drvPath` passes NixOS
# assertions from the Mac (a root fileSystem is mandatory).
# At install: overwrite this file wholesale with `nixos-generate-config` output
# on install day. DO NOT boot real hardware with this file.
{ ... }:
{
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
}
