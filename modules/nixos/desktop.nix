# Graphical session layer for the NixOS desktop:
# sway (Wayland; X clients under Xwayland), greetd/tuigreet, pipewire.
{ config, pkgs, user, ... }:
let
  sessions = config.services.displayManager.sessionData.desktops;

  # wl-pick: a grid of live window/display previews (ext-image-copy-capture,
  # sway 1.12), the screen-share window picker below. Not in nixpkgs
  # (2026-10). Tests need system fonts — none in the sandbox — so skipped.
  wl-pick = pkgs.rustPlatform.buildRustPackage {
    pname = "wl-pick";
    version = "0-unstable-2026-10-09";
    src = pkgs.fetchFromGitHub {
      owner = "mil-ad";
      repo = "wl-pick";
      rev = "93dda58852f3686c70a718325679e21262413aee";
      hash = "sha256-JQdRmRt+Hh34dKqP/bZYBpmWY3cIdw6y3Q9bpfJyo5A=";
    };
    cargoHash = "sha256-W/CjIZCQpBi6f0gPHata45/sat3LMev6S1XVAj6k8v8=";
    doCheck = false;
    meta = {
      description = "Live window picker for wlroots compositors";
      license = pkgs.lib.licenses.mit;
      mainProgram = "wl-pick";
    };
  };
in
{
  # sway: config is a plain dotfile (wm-linux/.config/sway/config, read live).
  # Why Wayland: each output at its own refresh rate with adaptive sync (Xorg
  # tied both monitors to one clock — the 180Hz AOC was held to 144), no
  # tearing. Games are X11 clients (Steam) under Xwayland, same frame rate.
  # The JIS layout is set in the sway config (input type:keyboard).
  programs.sway = {
    enable = true;
    # the module's default set pulls swaylock/brightnessctl too — not in
    # use. foot = $mod+Return (wm-linux/.config/foot; Wayland native, CPU
    # rendered, no bell. Not alacritty: mac-only by decision (2026-07-10),
    # GL-rendered); wmenu-run = $mod+d; swayidle blanks the screen; waybar
    # is the bar (`swaybar_command`, config wm-linux/.config/waybar: swaybar
    # draws no tray menus, waybar does). Screenshot tools are home-level
    # (modules/home/linux.nix).
    extraPackages = [ pkgs.foot pkgs.wmenu pkgs.swayidle pkgs.waybar ];
  };

  # Japanese input: fcitx5 + mozc. The module sets the IM env vars; the
  # daemon is started by sway (exec). Keys + input method list:
  # wm-linux/.config/fcitx5.
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = [ pkgs.fcitx5-mozc ];
  };

  # Key remaps at evdev level, below the compositor. Only remaps that depend
  # on timing or on the focused window live here (the rest is VIA, on the
  # board).
  services.keyd = {
    enable = true;
    keyboards.default.settings.main = {
      # Space = $mod (Mod4) while held, plain space on tap — hjkl/digits
      # become a thumb chord.
      # overloadi: a symbol key struck < 300ms ago = mid-sentence, plain
      # space, no matter how long it is held or what overlaps it. From rest:
      # overloadt2 — $mod after 250ms, or at once when another key is tapped
      # while space is down. (Raising the hold timeout alone does not help
      # slow typing: the overlap rule fires regardless; only the idle guard
      # does.)
      space = "overloadi(space, overloadt2(meta, space, 250), 300)";
      # かな (JIS, right thumb) = $mod+Shift while held: the "act on the
      # window" half of the sway bindings (move hjkl/digits, kill, monitor
      # menu, suspend). Free because mozc only maps it to "hiragana mode",
      # which is already the default — the IME never misses it.
      katakanahiragana = "layer(kana)";
    };
    # `[kana:M-S]`: a layer that is itself the Meta+Shift modifier pair, no
    # bindings of its own — keyd emits Mod4+Shift+<key> for whatever is
    # pressed under it, so the sway config needs no second $mod.
    keyboards.default.settings."kana:M-S" = { };
  };
  # Games want a real held space (jump/fly): keyd-application-mapper (started
  # by sway, config wm-linux/.config/keyd/app.conf) rebinds per focused
  # app_id over wlr-foreign-toplevel (an Xwayland window's app_id is its X
  # class). It talks over keyd's socket, which is only open to the `keyd`
  # group (== wheel-level trust; the module creates neither the group nor
  # the membership).
  users.groups.keyd = { };
  users.users.${user}.extraGroups = [ "keyd" ];

  # keyd 2.6.0's mapper dies on the first window title that is not valid
  # UTF-8 (its Wayland parser decodes strictly; xterm's Latin-1 WM_NAME did
  # it — 2026-10-11, crashed within a minute, space stayed $mod in games). nixpkgs builds the mapper as a private derivation inside keyd,
  # so it is rebuilt from keyd's source with the one-character fix and
  # linked over keyd's copy (postInstall as upstream's). Drop once upstream
  # decodes with errors='replace'.
  nixpkgs.overlays = [
    (final: prev:
      let
        mapper = final.python3Packages.buildPythonApplication {
          pname = "keyd-application-mapper";
          inherit (prev.keyd) version src;
          pyproject = false;
          postPatch = ''
            substituteInPlace scripts/keyd-application-mapper \
              --replace-fail /bin/sh ${final.runtimeShell} \
              --replace-fail "[0]-1].decode('utf8')" "[0]-1].decode('utf8', 'replace')"
          '';
          propagatedBuildInputs = with final.python3Packages; [
            python-xlib
            pygobject3.out
            dbus-python.out
          ];
          dontBuild = true;
          installPhase = "install -Dm555 -t $out/bin scripts/keyd-application-mapper";
          meta.mainProgram = "keyd-application-mapper";
        };
      in
      {
        keyd = prev.keyd.overrideAttrs {
          postInstall = ''
            ln -sf ${final.lib.getExe mapper} $out/bin/keyd-application-mapper
            rm -rf $out/etc
          '';
        };

        # xdg-desktop-portal-wlr 0.8.3 (nixpkgs 2026-07-05) casts one frame
        # and stalls (upstream #400): discord/chrome screen share froze on
        # the first frame (2026-10-13). nixpkgs has 0.8.4 since 2026-07-30;
        # drop once the flake input is past that.
        xdg-desktop-portal-wlr = prev.xdg-desktop-portal-wlr.overrideAttrs {
          version = "0.8.4";
          src = final.fetchFromGitHub {
            owner = "emersion";
            repo = "xdg-desktop-portal-wlr";
            rev = "v0.8.4";
            hash = "sha256-8Ohgkz13FcG8ddjjgreXkvFD2Q+zUDZnAM4Oh+C9P/s=";
          };
        };
      })
  ];
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

  # sway registers into sessionData (sessionPackages -> wayland-sessions).
  # The dir is a store path baked into greetd's config, and NixOS never
  # restarts greetd on a switch (it owns the running session) — a new or
  # removed session entry shows up only after `systemctl restart greetd`
  # from a TTY, or a reboot (2026-10-11: sway was invisible until then).
  # NOT /run/current-system/sw/share/... — never populated without sddm.
  services.greetd = {
    enable = true;
    useTextGreeter = true; # keeps boot/journal spam off the TUI
    settings.default_session = {
      user = "greeter";
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${sessions}/share/wayland-sessions";
    };
  };

  # Screen sharing: programs.sway enables xdg-desktop-portal-wlr, which
  # asks a chooser what to cast. Its default choosers (slurp, wofi, ...) are
  # searched on the service's PATH — a systemd user unit with a bare
  # coreutils PATH, so none was found and discord fell back to capturing
  # the Xwayland screen: only its own window.
  # Chooser (dmenu type: the portal pipes what the app may pick — "Monitor:"
  # lines for a screen request, "Window:" lines for a window request —
  # and reads the chosen line back):
  #   screens  -> slurp: the outputs are overlaid, click one
  #   windows  -> wl-pick: a grid of live previews of the open windows
  #               (discord's "Applications" tab); a window streams from any
  #               workspace, visible or not (sway 1.12: ext-foreign-toplevel-
  #               image-capture-source). Enter/click picks, Esc cancels.
  # Chromium/Electron open two portal sessions per share (one for the
  # picker's thumbnail, one for the stream), so a bare chooser asks twice;
  # a pick is remembered for 15 s and answers the second request itself —
  # by id (the text in the label's last parentheses), since a window title
  # may change in between, and only if that id is in the offered list.
  # Colors/font: Everforest as in the sway bar (wm-linux/.config/sway/config).
  # The sway config must `include /etc/sway/config.d/*` for the portal to
  # see the session at all (see wm-linux/.config/sway/config).
  xdg.portal.wlr.settings.screencast = {
    chooser_type = "dmenu";
    chooser_cmd = toString (pkgs.writeShellScript "screencast-chooser" ''
      list=$(cat)
      cache=''${XDG_RUNTIME_DIR:-/tmp}/screencast-chooser.last
      find_key() { printf '%s\n' "$list" | grep -m1 -E -- "^Monitor: $1( |$)|\($1\)$"; }
      if [ -f "$cache" ] && [ $(( $(date +%s) - $(stat -c %Y "$cache") )) -lt 15 ]; then
        line=$(find_key "$(sed -n 's/.*(\([^()]*\))$/\1/p' "$cache")")
        if [ -n "$line" ]; then printf '%s\n' "$line"; exit 0; fi
      fi
      if printf '%s\n' "$list" | grep -q '^Window: '; then
        pick=$(${wl-pick}/bin/wl-pick --format portal --no-outputs \
          --config ${pkgs.writeText "wl-pick.conf" ''
            background     = #2d353b
            foreground     = #d3c6aa
            selection      = #a7c080
            selection-text = #2d353b
            border         = #a7c080
            font           = FiraCode Nerd Font
            max-columns    = 3
            max-rows       = 3
          ''}) || exit 1
        key=''${pick#Window: }
      else
        key=$(${pkgs.slurp}/bin/slurp -f %o -or -b 2d353b99 -c a7c080ff -s a7c08033 -w 3) || exit 1
      fi
      line=$(find_key "$key")
      [ -n "$line" ] || exit 1
      printf '%s\n' "$line" | tee "$cache"
    '');
  };

  # audio (graphical-desktop mkDefaults some of this; explicit = intent)
  security.rtkit.enable = true; # realtime scheduling for pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    # alsa.support32Bit lives in gaming.nix — i686, x86_64-only

    # Steam Remote Play (Steam Link): Steam loads its own "steam-streaming-playback"
    # sink, makes it the default (games play there) and reads the default back
    # 0.3ms later — before wireplumber switched — so it records the OLD default's
    # monitor (headset or DP audio): audible at the desk, silent on the client.
    # Pin the monitor capture to Steam's sink; other Steam captures (mic) untouched.
    # Needs: systemctl --user restart pipewire-pulse (kills Steam's audio streams —
    # between sessions). Live fix for a running stream:
    #   pw-metadata $(wpctl status | grep -oP '\d+(?=\. Steam\s*$)') target.object steam-streaming-playback
    extraConfig.pipewire-pulse."60-steam-streaming-capture" = {
      "stream.rules" = [
        {
          matches = [
            {
              "application.process.binary" = "steam";
              "stream.capture.sink" = "true";
            }
          ];
          actions.update-props."target.object" = "steam-streaming-playback";
        }
      ];
    };
  };

  # xrandr: monitor-layout sets Xwayland's primary output (games fullscreen there)
  environment.systemPackages = [
    pkgs.xrandr
    pkgs.keyd # keyd-application-mapper on PATH for the sway exec (service alone installs nothing)
  ];
}
