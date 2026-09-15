# Home base profile — every machine, always.
# (home.stateVersion is per-host and lives in hosts/*/)
{ config, lib, pkgs, ... }:
{
  home.file = import ./lib/stow.nix { inherit config lib; } [
    "term"
    "git"
    "less"
  ];

  home.packages = with pkgs; [
    git
    delta
    less # >= 582 reads ~/.lesskey (stow pkg "less") directly; macOS ships 581
    tmux
    fzf
    ripgrep
    jq
    watch
  ];
}
