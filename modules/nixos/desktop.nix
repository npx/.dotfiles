# Graphical session layer for the NixOS desktop:
# X11 + i3 + greetd/tuigreet + pipewire.
{ config, pkgs, user, ... }:
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
    xkb.layout = "jp"; # JIS board (Apex Pro Mini)
  };

  # Japanese input: fcitx5 + mozc. The module sets the IM env vars; the
  # daemon is started by i3 (no XDG autostart there). Keys + input method
  # list: wm-linux/.config/fcitx5.
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = [ pkgs.fcitx5-mozc ];
  };

  # Key remaps at evdev level, below X. Not xmodmap: X drops its xmodmap
  # edits whenever a keyboard device appears — every keyd restart adds one
  # (its virtual keyboard), as does re-plugging the headset or mouse.
  services.keyd = {
    enable = true;
    keyboards.default.settings.main = {
      capslock = "layer(control)"; # keyd's form for a modifier key, not the bare keycode
      # Space = $mod (Mod4) while held, plain space on tap — i3 hjkl/digits
      # become a thumb chord.
      # overloadi: a symbol key struck < 300ms ago = mid-sentence, plain
      # space, no matter how long it is held or what overlaps it. From rest:
      # overloadt2 — $mod after 250ms, or at once when another key is tapped
      # while space is down. (Raising the hold timeout alone does not help
      # slow typing: the overlap rule fires regardless; only the idle guard
      # does.)
      space = "overloadi(space, overloadt2(meta, space, 250), 300)";
      # かな (JIS, right thumb) = $mod+Shift while held: the "act on the
      # window" half of the i3 bindings (move hjkl/digits, kill, monitor
      # menu, suspend). Free because mozc only maps it to "hiragana mode",
      # which is already the default — the IME never misses it.
      katakanahiragana = "layer(kana)";
      # No Print key on this board: End is Print, Home a second Backspace.
      # `sysrq` is PrtSc itself (keyd's `print` is KEY_PRINT, the consumer-
      # page "AC Print"); X maps it to the Print keysym the i3 screenshot
      # bindings use. Modifier layers fall through to main with their
      # modifier applied, so Shift+End / mod+End stay the window / whole-
      # screen shots.
      end = "sysrq";
      home = "backspace";
    };
    # `[kana:M-S]`: a layer that is itself the Meta+Shift modifier pair, no
    # bindings of its own — keyd emits Mod4+Shift+<key> for whatever is
    # pressed under it, so the i3 config needs no second $mod.
    keyboards.default.settings."kana:M-S" = { };
  };
  # Games want a real held space (jump/fly): keyd-application-mapper (started
  # by i3, config wm-linux/.config/keyd/app.conf) rebinds per focused WM_CLASS
  # over keyd's socket, which is only open to the `keyd` group (== wheel-level
  # trust; the module creates neither the group nor the membership).
  users.groups.keyd = { };
  users.users.${user}.extraGroups = [ "keyd" ];
  # The module's hardening bounds keyd to CAP_SYS_NICE/CAP_IPC_LOCK. keyd
  # setgid()s to `keyd` to hand the group the socket and exits when that
  # fails — so the group above alone kills the daemon at every start
  # ("setgid: Operation not permitted", space a plain key again). Bounding
  # sets union across lines; seccomp already lets setgid through.
  systemd.services.keyd.serviceConfig.CapabilityBoundingSet = [ "CAP_SETGID" ];

  # Rainy 75 (Wobkey, JIS): the firmware is VIA-compatible — remaps are done
  # in the browser (usevia.app, WebHID) over the board's raw-HID interface,
  # no vendor software, no flashing. hidraw nodes are root-only by default;
  # uaccess hands the seated user an ACL. Must sort before 73-seat-late.rules
  # (which turns the tag into the ACL), so NOT services.udev.extraRules
  # (= 99-local.rules). 0x5055 = wired, 0x5088 = the 2.4G dongle.
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "rainy75-udev-rules";
      destination = "/etc/udev/rules.d/70-rainy75.rules";
      text = ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="320f", ATTRS{idProduct}=="5055|5088", TAG+="uaccess"
      '';
    })
  ];

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
    pkgs.keyd # keyd-application-mapper on PATH for i3 exec (service alone installs nothing)
  ];
}
