# Proton VPN over WireGuard.
#
# Off at boot on purpose. Proton's generated config is a full tunnel
# (AllowedIPs = 0.0.0.0/0, ::/0), so every packet goes out through their exit
# and back behind their NAT — the opposite of what the enp42s0 EEE fix in
# hosts/desktop bought for SF6's UDP P2P. Bring it up only when wanted:
#   sudo systemctl start wg-quick-proton
#   sudo systemctl stop  wg-quick-proton
#   wg show                      # confirm the handshake
#
# The .conf is machine-local and untracked — same posture as ~/.secrets. It
# carries the WireGuard private key, so it must never reach the nix store;
# `configFile` is a str (not a path), read by the unit at start, so this
# reference does NOT copy it in at build time. Fetch it from
# account.protonvpn.com -> Downloads -> WireGuard configuration, then:
#   sudo install -Dm600 ~/Downloads/<name>.conf /etc/wireguard/proton.conf
# Proton expires generated configs after a year; regenerate and drop in place.
#
# One interface per exit server: add a second attr here for a second .conf.
{ pkgs, ... }:
{
  networking.wg-quick.interfaces.proton = {
    configFile = "/etc/wireguard/proton.conf";
    autostart = false;
  };

  # the unit carries wireguard-tools in its own PATH; this is for `wg show`
  # from an interactive shell
  environment.systemPackages = [ pkgs.wireguard-tools ];
}
