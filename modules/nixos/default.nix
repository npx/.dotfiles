# NixOS system layer — every NixOS host (mirror of modules/darwin/default.nix).
{ inputs, user, pkgs, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  # mac gets TZ from macOS; NixOS defaults to UTC without this
  time.timeZone = "Asia/Tokyo";

  users.users.${user} = {
    isNormalUser = true;
    home = "/home/${user}";
    shell = pkgs.zsh; # /etc/shells entry via programs.zsh.enable (modules/shared)
    extraGroups = [ "wheel" ]; # other modules append (lists merge)
  };

  # mason's prebuilt LSP binaries need the standard loader path
  programs.nix-ld.enable = true;

  # system.stateVersion is per-host (hosts/*/default.nix)
}
