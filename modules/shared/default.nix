# Applies to every host (darwin and nixos).
{ inputs, pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # steam/discord/chrome are unfree; set here so both hosts evaluate
  # identical nixpkgs config (no-op where nothing unfree is used).
  nixpkgs.config.allowUnfree = true;

  # same attribute works on darwin (/Library/Fonts/Nix Fonts) and NixOS
  fonts.packages = [ pkgs.nerd-fonts.fira-code ];

  environment.systemPackages = [ pkgs.vim ];

  programs.zsh.enable = true; # nixos: required for shell = pkgs.zsh (/etc/shells)

  # home-manager module *imports* stay per-platform (darwinModules vs
  # nixosModules); only the settings are shared.
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # If activation finds a file it doesn't own (e.g. an old stow link),
    # move it aside instead of aborting.
    backupFileExtension = "hm-backup";
  };

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
}
