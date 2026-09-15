# Jellyfin media server — watch from the iPhone (Swiftfin app) over LAN.
# All state (settings, users, watch progress) lives in /var/lib/jellyfin;
# libraries are added in the web UI (http://desktop:8096) and only READ media.
{ user, ... }:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true; # 8096 http (+ 8920 https, 1900/7359 client discovery)
  };

  # VAAPI hardware transcoding on the AMD GPU needs the render node
  # (/dev/dri/renderD128); enable under Dashboard → Playback → Transcoding
  users.users.jellyfin.extraGroups = [ "render" ];

  # Library root. setgid (2) makes new subdirs inherit the jellyfin group,
  # so anything ${user} drops in stays readable to the server without chmod.
  systemd.tmpfiles.rules = [
    "d /srv/media 2775 ${user} jellyfin -"
  ];
}
