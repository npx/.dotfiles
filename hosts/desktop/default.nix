# Gaming desktop — x86_64 NixOS.
{ user, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix # PLACEHOLDER until install day
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/gaming.nix # x86_64-only
    ../../modules/nixos/gpu-amd.nix # Radeon Navi 22 (12G)
  ];

  networking.hostName = "desktop"; # = flake attr; nixos-rebuild auto-picks
  nixpkgs.hostPlatform = "x86_64-linux";

  # kept OUT of hardware-configuration.nix so it survives regeneration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # same GUI apps as the mac (casks there, nixpkgs here)
  environment.systemPackages = with pkgs; [
    discord
    google-chrome
  ];

  home-manager.users.${user} = {
    imports = [
      ../../modules/home/core.nix
      ../../modules/home/dev.nix # add/remove = full dev env on/off
      ../../modules/home/linux.nix
    ];
    home.stateVersion = "26.05"; # re-pin at install
  };

  system.stateVersion = "26.05"; # set at install, never change after
}
