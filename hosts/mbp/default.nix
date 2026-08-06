# MacBook Pro — dev machine.
{ user, ... }:
{
  networking.hostName = "MacBook-Pro";
  networking.localHostName = "MacBook-Pro";

  nixpkgs.hostPlatform = "aarch64-darwin";

  # pre-existing install adopted at stateVersion 6 — never change
  system.stateVersion = 6;

  home-manager.users.${user} = {
    imports = [
      ../../modules/home/core.nix
      ../../modules/home/dev.nix
      ../../modules/home/darwin.nix
    ];
    home.stateVersion = "24.11";
  };
}
