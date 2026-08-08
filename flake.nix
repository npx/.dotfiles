{
  description = "npx dotfiles and machine configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, nix-homebrew }:
  let
    user = "ybaron";
  in
  {
    # $ sudo darwin-rebuild switch --flake .
    # (attr name must match `scutil --get LocalHostName`)
    darwinConfigurations."MacBook-Pro" = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit inputs user; };
      modules = [
        ./modules/shared
        ./modules/darwin
        ./hosts/mbp
      ];
    };

    # $ sudo nixos-rebuild switch --flake .
    # (attr name must match networking.hostName — nixos-rebuild auto-picks)
    nixosConfigurations."desktop" = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs user; };
      modules = [
        ./modules/shared
        ./modules/nixos
        ./hosts/desktop
      ];
    };

    nixosConfigurations."macbook" = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs user; };
      modules = [
        ./modules/shared
        ./modules/nixos
        ./hosts/macbook
      ];
    };

    # Installer ISO for the 2013 macbook: the stock ISO lacks the proprietary
    # broadcom wl driver, so its wifi is dead during install. This bakes it in
    # (plus usbmuxd for iPhone-USB-tether as fallback).
    # $ nix build .#installer-iso   → result/iso/*.iso, then dd to the stick
    nixosConfigurations."installer" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ({ config, lib, ... }: {
          nixpkgs.config.allowUnfree = true;
          # same acceptance as hosts/macbook: wl is the only BCM4360 driver
          nixpkgs.config.allowInsecurePredicate = pkg: lib.getName pkg == "broadcom-sta";
          boot.kernelModules = [ "wl" ];
          boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
          # in-tree brcm/b43 drivers claim the chip first and don't work — keep them out
          boot.blacklistedKernelModules = [ "b43" "bcma" "brcmsmac" "brcmfmac" "ssb" ];
          services.usbmuxd.enable = true; # iPhone tethering: hotspot on + trust prompt
        })
      ];
    };

    packages.x86_64-linux.installer-iso =
      self.nixosConfigurations."installer".config.system.build.isoImage;

  };
}
