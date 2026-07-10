# Home bits that only make sense on macOS (aerospace, sketchybar).
{ config, lib, ... }:
{
  home.file = import ./lib/stow.nix { inherit config lib; } [
    "wm"
  ];
}
