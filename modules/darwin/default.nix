# macOS system layer: nix-darwin + nix-homebrew + home-manager wiring.
{ inputs, user, pkgs, config, ... }:
{
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.home-manager.darwinModules.home-manager
  ];

  # Required for user-scoped options (homebrew, system.defaults) since the
  # nix-darwin root-activation change.
  system.primaryUser = user;

  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
  };

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = user;
    # Adopt the existing imperative Homebrew installation in place.
    autoMigrate = true;
    # Taps stay mutable (nix-homebrew default): the declared taps below are
    # ensured tapped, not pinned as flake inputs.
  };

  homebrew = {
    enable = true;
    # trusted: Homebrew 6 refuses unqualified formulas from untrusted
    # third-party taps (HOMEBREW_REQUIRE_TAP_TRUST)
    taps = [
      { name = "nikitabobko/tap"; trusted = true; } # aerospace
      { name = "felixkratz/formulae"; trusted = true; } # sketchybar
    ];
    # CLI stays in nixpkgs. Exception: sketchybar is launched by aerospace
    # via bare PATH name from its own launchd context; the brew path is what
    # that context resolves today.
    brews = [
      "sketchybar"
    ];
    casks = [
      "nikitabobko/tap/aerospace"
      "alacritty"
      "docker-desktop"
      "google-chrome"
      "discord"
      "slack"
      "microsoft-teams"
      "zoom"
      "utm"
    ];
    onActivation = {
      # NOT "check": that aborts the whole activation whenever anything
      # undeclared is installed; the postActivation drift report below
      # warns instead of blocking.
      cleanup = "none";
      autoUpdate = false;
      upgrade = false;
    };
  };

  system.defaults = {
    # AeroSpace docs: disable "automatically rearrange Spaces"
    dock.mru-spaces = false;
    # fast key repeat + hold-to-repeat for vim
    NSGlobalDomain = {
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      ApplePressAndHoldEnabled = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
    };
  };

  # Touch ID for sudo (survives macOS updates via pam sudo_local include);
  # reattach makes it work inside tmux.
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  # Drift report, never blocks: lists brew things installed but not declared
  # (brew bundle cleanup without --force only prints what it WOULD remove).
  system.activationScripts.postActivation.text = ''
    echo "==> homebrew drift (installed but undeclared):"
    sudo --user=${user} --set-home env HOMEBREW_NO_AUTO_UPDATE=1 \
      /opt/homebrew/bin/brew bundle cleanup \
      --file=${pkgs.writeText "Brewfile" config.homebrew.brewfile} || true
  '';
}
