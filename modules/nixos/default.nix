# NixOS system layer — every NixOS host (mirror of modules/darwin/default.nix).
{ inputs, user, pkgs, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  # steam/discord/chrome are unfree; set in the shared base so both hosts
  # evaluate identical nixpkgs config (no-op where nothing unfree is used).
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [ pkgs.vim ];

  # mac gets TZ from macOS; NixOS defaults to UTC without this
  time.timeZone = "Asia/Tokyo";

  programs.zsh.enable = true; # required for shell = pkgs.zsh (/etc/shells)

  users.users.${user} = {
    isNormalUser = true;
    home = "/home/${user}";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ]; # gaming.nix appends "gamemode" (lists merge)
  };

  # mason's prebuilt LSP binaries need the standard loader path
  programs.nix-ld.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # If activation finds a file it doesn't own (e.g. an old stow link),
    # move it aside instead of aborting.
    backupFileExtension = "hm-backup";
  };

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  # system.stateVersion is per-host (hosts/*/default.nix)
}
