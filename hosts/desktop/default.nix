# Gaming desktop — x86_64 NixOS.
{ user, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix # real: generated 2026-08-02 against nvme0n1
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/gaming.nix # x86_64-only
    ../../modules/nixos/gpu-amd.nix # Radeon Navi 22 (12G)
  ];

  networking.hostName = "desktop"; # = flake attr; nixos-rebuild auto-picks

  services.openssh.enable = true; # remote management from the mac (LAN)
  nixpkgs.hostPlatform = "x86_64-linux";

  # kept OUT of hardware-configuration.nix so it survived regeneration
  # (it did — the file was regenerated 2026-08-02 and these stayed put)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # The whole 1TB, reclaimed from Windows 2026-08-02. Games and personal data
  # share ONE filesystem on purpose: the previous split (195G games + 590G NTFS)
  # could not be grown, because the free space sat *before* /mnt/games on the
  # platter and ext4 only extends at its end.
  # 785G until the old install's tail partitions are released, then 931.5G.
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-label/data";
    fsType = "ext4";
  };

  # same GUI apps as the mac (casks there, nixpkgs here)
  environment.systemPackages = with pkgs; [
    discord
    google-chrome
    ethtool # verify the EEE workaround below (--show-eee)

    # disk tooling — this host's partition layout is hand-managed, not disko'd.
    # Needed on BOTH sides of the windows-eradication migration: gptfdisk to
    # cut partitions, parted for partprobe, cloud-utils for growpart when the
    # data partition absorbs the freed tail, efibootmgr to prune the dead
    # Windows boot entry. None ship in the default system profile.
    gptfdisk
    parted
    cloud-utils
    efibootmgr
  ];

  # RTL8125B on the in-kernel r8169 driver renegotiates the whole link instead
  # of resuming from EEE low-power idle — ~5s outages that kill SF6's UDP P2P
  # session mid-match. ethtool state is NOT persistent, so
  # bind to the device unit: this reapplies every time the NIC appears, not
  # just at boot.
  systemd.services.disable-eee-enp42s0 = {
    description = "Disable Energy Efficient Ethernet on enp42s0";
    wantedBy = [ "sys-subsystem-net-devices-enp42s0.device" ];
    after = [ "sys-subsystem-net-devices-enp42s0.device" ];
    bindsTo = [ "sys-subsystem-net-devices-enp42s0.device" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.ethtool}/bin/ethtool --set-eee enp42s0 eee off";
    };
  };

  home-manager.users.${user} = {
    imports = [
      ../../modules/home/core.nix
      ../../modules/home/dev.nix # add/remove = full dev env on/off
      ../../modules/home/linux.nix
    ];
    home.stateVersion = "26.11"; # re-pinned at the 2026-08-02 install
  };

  # set at the 2026-08-02 install (nvme0n1, nixpkgs 26.11) — never change after
  system.stateVersion = "26.11";
}
