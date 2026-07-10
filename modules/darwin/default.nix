# macOS system layer: nix-darwin + nix-homebrew + home-manager wiring.
{ inputs, user, pkgs, ... }:
{
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.home-manager.darwinModules.home-manager
  ];

  environment.systemPackages = [ pkgs.vim ];

  programs.zsh.enable = true;

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
    # Taps stay mutable: qmk/osx-cross/shopify taps are used imperatively
    # for keyboard-firmware work; pinning all taps as flake inputs would
    # fight that workflow.
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
    # that context resolves today. (nvm is NOT here: the active nvm is the
    # standalone ~/.nvm installer, not the brew formula — fnm replaces it.)
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
      cleanup = "none"; # -> "check" once the declared lists are complete
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

  # "vpn proxy" network location: Wi-Fi routes via a PAC served from the UTM
  # VM. Created once (idempotent); networksetup setters only touch the current
  # location, hence the switch/switch-back dance. Selecting the location stays
  # manual (menu bar or `scselect "vpn proxy"`).
  system.activationScripts.extraActivation.text = ''
    if ! /usr/sbin/networksetup -listlocations | grep -qx "vpn proxy"; then
      echo "creating 'vpn proxy' network location..."
      /usr/sbin/networksetup -createlocation "vpn proxy" populate
      /usr/sbin/networksetup -switchtolocation "vpn proxy"
      /usr/sbin/networksetup -setautoproxyurl "Wi-Fi" "http://192.168.64.2:8080/proxy.pac"
      /usr/sbin/networksetup -switchtolocation "Automatic"
    fi
  '';

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # If activation finds a file it doesn't own (e.g. an old stow link),
    # move it aside instead of aborting.
    backupFileExtension = "hm-backup";
  };

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 6;
}
