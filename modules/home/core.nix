# Home base profile — every machine, always.
# (home.stateVersion is per-host and lives in hosts/*/)
{ config, lib, pkgs, ... }:
let
  stow = import ./lib/stow.nix { inherit config lib; };
in
{
  home.file = stow.link [
    "term"
    "git"
    "less"
  ];
  # once, for every container, whatever the other modules link
  home.activation.stowUnfold = stow.unfold;

  home.packages = with pkgs; [
    git
    delta
    less # >= 582 reads ~/.lesskey (stow pkg "less") directly; macOS ships 581
    tmux
    fzf
    ripgrep
    jq
    watch
    btop
  ];
}
