# MacBook Pro — dev machine.
{ user, ... }:
{
  networking.hostName = "MacBook-Pro";
  networking.localHostName = "MacBook-Pro";

  nixpkgs.hostPlatform = "aarch64-darwin";

  home-manager.users.${user} = {
    imports = [
      ../../modules/home/core.nix
      ../../modules/home/dev.nix
      ../../modules/home/darwin.nix
    ];
    home.stateVersion = "24.11";
  };
}
