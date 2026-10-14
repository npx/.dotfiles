# Home bits that only make sense on Linux (linux WM dotfiles, clipboard
# tools). Mirror of modules/home/darwin.nix.
# wm-linux/.bin holds scripts that must NOT reach the work macbook
# (claude-remote: phone access to the projects on this machine only).
{ config, lib, pkgs, ... }:
{
  home.file = (import ./lib/stow.nix { inherit config lib; }).link [
    "wm-linux"
  ];

  home.packages = with pkgs; [
    wl-clipboard # tmux copy, nvim clipboard, screenshots
    gcc # nvim-treesitter compiles parsers at runtime; macOS has xcode clang, linux has nothing
    python3 # mason installs pypi packages (ruff, ty) via venv+pip; macOS has CLT python
    pavucontrol # pipewire GUI mixer — per-app + per-device routing
    grim # screenshots (sway Print bindings) ...
    slurp # ... with the region picker
    wl-mirror # "mirror" layout: sway cannot clone an output, monitor-layout shows a live copy instead
  ];
}
