# Applies to every host (darwin and nixos).
{ pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # same attribute works on darwin (/Library/Fonts/Nix Fonts) and NixOS
  fonts.packages = [ pkgs.nerd-fonts.fira-code ];
}
