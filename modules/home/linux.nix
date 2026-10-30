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
    xclip # tmux X11 branch + nvim clipboard autodetect under i3
    wl-clipboard # tmux Wayland branch (desktop's gamescope session is Wayland)
    gcc # nvim-treesitter compiles parsers at runtime; macOS has xcode clang, linux has nothing
    python3 # mason installs pypi packages (ruff, ty) via venv+pip; macOS has CLT python
    pavucontrol # pipewire GUI mixer — per-app + per-device routing
    maim # X11 screenshots; pulls slop for the region picker (i3 Print bindings)
    xdotool # active-window id for the Shift+Print window shot
  ];
}
