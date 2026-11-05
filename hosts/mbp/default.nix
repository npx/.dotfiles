# MacBook Pro — dev machine.
{ user, ... }:
{
  networking.hostName = "MacBook-Pro";
  networking.localHostName = "MacBook-Pro";

  nixpkgs.hostPlatform = "aarch64-darwin";

  # pre-existing install adopted at stateVersion 6 — never change
  system.stateVersion = 6;

  # Sleep hygiene: sleep must be real sleep, no dark wakes. nix-darwin's power
  # module has none of these, so set them on activation (runs as root).
  # Verify with: pmset -g custom
  #
  # womp: with "Wake for network access" on, an incoming packet (pmset log:
  #   "E_RX_IP_PACKET ARPT") woke the Mac ~30 s after every manual sleep.
  # tcpkeepalive (AC only): Apple push keep-alives dark-woke the Mac every
  #   ~6 min ("DarkWake ... due to smc wifibt"). USB gets re-enumerated on
  #   each one, so the mic lit up and Discord played sounds at night.
  #   Costs Find My Mac + push notifications while docked; battery keeps it.
  # powernap (AC only): background jobs (Photos image analysis) stretched
  #   those dark wakes to an hour at a time.
  # The VPN drops on every sleep either way; that is inherent to sleep.
  system.activationScripts.postActivation.text = ''
    echo "==> power: wake for network access off"
    pmset -a womp 0
    echo "==> power: no dark wakes on AC (push keep-alive, power nap)"
    pmset -c tcpkeepalive 0
    pmset -c powernap 0
  '';

  home-manager.users.${user} = {
    imports = [
      ../../modules/home/core.nix
      ../../modules/home/dev.nix
      ../../modules/home/darwin.nix
    ];
    home.stateVersion = "24.11";
  };
}
