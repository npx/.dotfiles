# Gaming desktop — x86_64 NixOS.
# GPU: AMD Radeon Navi 22 (12G) — amdgpu is in-kernel, Vulkan/RADV comes with
# mesa defaults; no GPU-specific config needed.
{ user, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix # real: generated 2026-08-02 against nvme0n1
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/gaming.nix # x86_64-only
  ];

  networking.hostName = "desktop"; # = flake attr; nixos-rebuild auto-picks

  services.openssh.enable = true; # remote management from the mac (LAN)
  nixpkgs.hostPlatform = "x86_64-linux";

  # kept OUT of hardware-configuration.nix so it survived regeneration
  # (it did — the file was regenerated 2026-08-02 and these stayed put)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # The whole 1TB (931.5G), reclaimed from Windows 2026-08-02. Games and
  # personal data share ONE filesystem on purpose: a split cannot be regrown
  # when the free space sits before a partition — ext4 only extends at its end.
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-label/data";
    fsType = "ext4";
  };

  # monitor-layout (term/.bin, i3 exec + $mod+Shift+m): the iiyama is shared
  # with the macbook over HDMI and keeps its DP link up on either input, so
  # the only way to know which one it shows is asking it over DDC/CI
  # (ddcutil, VCP 0x60). hardware.i2c loads i2c-dev and grants the i2c group
  # the /dev/i2c-* nodes.
  hardware.i2c.enable = true;

  # same GUI apps as the mac (casks there, nixpkgs here)
  environment.systemPackages = with pkgs; [
    discord
    google-chrome
    ddcutil # monitor-layout
  ];

  # suspend from i3 ($mod+Shift+s). r8169 re-inits the PHY on resume, which
  # can resurrect EEE — powerManagement.enable provides post-resume.target,
  # where the disable-eee oneshot below gets re-run
  powerManagement.enable = true;
  powerManagement.resumeCommands = "${pkgs.systemd}/bin/systemctl restart disable-eee-enp42s0.service";

  # engine for dev.nix's docker-compose — remove together with the dev import
  virtualisation.docker.enable = true;
  users.users.${user}.extraGroups = [ "docker" "i2c" ]; # lists merge (wheel, gamemode); i2c = ddcutil

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
