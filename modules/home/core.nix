# Home base profile — every machine, always.
# (home.stateVersion is per-host and lives in hosts/*/)
{ config, lib, pkgs, ... }:
{
  home.file = import ./lib/stow.nix { inherit config lib; } [
    "term"
    "git"
  ];

  home.packages = with pkgs; [
    git
    tmux
    fzf
    ripgrep
    jq
    watch
  ];
}
