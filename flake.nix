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

  };
}
