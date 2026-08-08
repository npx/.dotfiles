# 2013 MacBook — media/couch machine (browser + VPN; no dev, no gaming).
{ config, lib, user, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix # placeholder: replace with nixos-generate-config output at install
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/vpn.nix
  ];

  networking.hostName = "macbook"; # = flake attr; nixos-rebuild auto-picks
  nixpkgs.hostPlatform = "x86_64-linux";

  services.openssh.enable = true; # remote management from the mac (LAN)

  boot.loader.systemd-boot.enable = true; # works on Apple EFI
  boot.loader.efi.canTouchEfiVariables = true;

  # Broadcom BCM4360 wifi — only the proprietary wl driver supports it
  # (allowUnfree is already global in modules/shared). The installer ISO does
  # NOT carry it: install over ethernet adapter or USB tether.
  boot.kernelModules = [ "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  # nixpkgs marks wl insecure (unmaintained, CVE-2019-9501/9502) — accepted:
  # it is the only driver for this chip. By name, not name-version, so kernel
  # bumps don't re-break eval.
  nixpkgs.config.allowInsecurePredicate = pkg: lib.getName pkg == "broadcom-sta";

  # laptop bits: wifi roaming (nmtui) + battery life
  networking.networkmanager.enable = true;
  users.users.${user}.extraGroups = [ "networkmanager" ]; # lists merge (wheel)
  services.tlp.enable = true;

  # retina panel: fonts scale via Xft.dpi in ~/.Xresources.local (untracked,
  # machine-local), but cursors ignore X resources in most toolkits — the env
  # var is what libXcursor and GTK actually honor. 48 = 2x the default 24.
  # SIZE alone does nothing without an Xcursor theme installed: the fallback
  # is the fixed-size X core cursor font. bibata ships all sizes up to 96.
  environment.variables.XCURSOR_SIZE = "48";
  environment.variables.XCURSOR_THEME = "Bibata-Modern-Classic";

  environment.systemPackages = with pkgs; [
    bibata-cursors # lands in XCURSOR_PATH via share/icons
    google-chrome
    # media keys, bound in wm-linux/.config/i3/config:
    brightnessctl # screen + smc::kbd_backlight via logind, no perms needed
    playerctl # play/pause/next reach Chrome over MPRIS
  ];

  home-manager.users.${user} = {
    imports = [
      ../../modules/home/core.nix
      # no dev.nix on purpose — claude CLI via native installer if ever needed
      ../../modules/home/linux.nix
    ];
    home.stateVersion = "26.11";
  };

  # pin at install — never change after
  system.stateVersion = "26.11";
}
