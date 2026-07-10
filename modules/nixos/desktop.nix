# Graphical session layer for the NixOS desktop:
# X11 + i3 + greetd/tuigreet + pipewire.
{ config, pkgs, ... }:
let
  sessions = config.services.displayManager.sessionData.desktops;
in
{
  services.xserver = {
    enable = true;
    # i3 config is a plain dotfile (wm-linux/.config/i3/config, stow-linked);
    # windowManager.i3.configFile stays null (default) so it is read live.
    # Module's default extraPackages (dmenu + i3status) kept — config uses both.
    windowManager.i3.enable = true;
    desktopManager.xterm.enable = false;
    # tuigreet launches xsession entries via its default wrapper
    # (`startx /usr/bin/env`); startx.enable provides the binary.
    displayManager.startx.enable = true;
    xkb.layout = "us";
  };

  # Sessions auto-register into sessionData: i3 -> xsessions, steam gamescope
  # session (desktop host only) -> wayland-sessions; tuigreet lists both dirs.
  # NOT /run/current-system/sw/share/... — never populated without sddm.
  services.greetd = {
    enable = true;
    useTextGreeter = true; # keeps boot/journal spam off the TUI
    settings.default_session = {
      user = "greeter";
      # --sessions = Wayland dirs, --xsessions = X11 dirs (only the latter get
      # the startx wrapper — an X session listed under --sessions execs bare
      # and dies with "cannot open display")
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${sessions}/share/wayland-sessions --xsessions ${sessions}/share/xsessions";
    };
  };

  # audio (graphical-desktop mkDefaults some of this; explicit = intent)
  security.rtkit.enable = true; # realtime scheduling for pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    # alsa.support32Bit lives in gaming.nix — i686, x86_64-only
  };

  # i3 binds $mod+Return to xterm — the session module owns its terminal.
  # Deliberately NOT alacritty: mac-only by decision (2026-07-10), and it is
  # GL-rendered — unusable on GL-less VMs anyway. xterm = no bells; styling
  # comes from ~/.Xresources (wm-linux), loaded by i3 via xrdb.
  environment.systemPackages = [
    pkgs.xterm
    pkgs.xrdb
  ];
}
