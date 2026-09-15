# Home bits that only make sense on Linux (linux WM dotfiles, clipboard
# tools). Mirror of modules/home/darwin.nix.
{ config, lib, pkgs, ... }:
{
  home.file = import ./lib/stow.nix { inherit config lib; } [
    "wm-linux"
  ];

  home.packages = with pkgs; [
    xclip # tmux X11 branch + nvim clipboard autodetect under i3
    wl-clipboard # tmux Wayland branch (desktop's gamescope session is Wayland)
    gcc # nvim-treesitter compiles parsers at runtime; macOS has xcode clang, linux has nothing
    python3 # mason installs pypi packages (ruff, ty) via venv+pip; macOS has CLT python
    pavucontrol # pipewire GUI mixer — per-app + per-device routing
  ];
}
