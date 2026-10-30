# Steam stack — IMPORT ONLY FROM x86_64 HOSTS (hosts/desktop). programs.steam
# sets hardware.graphics.enable32Bit which trips an eval-time assertion on
# aarch64. Explicit import lists are the repo's on/off mechanism.
{ pkgs, user, ... }:
{
  programs.steam = {
    enable = true; # auto-enables hardware.graphics.{enable,enable32Bit} + steam-hardware
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    protontricks.enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  programs.gamemode.enable = true;
  # renice silently no-ops without the group; GE-Proton stopped auto-running
  # gamemode in 2022 -> `gamemoderun %command%` per game
  users.users.${user}.extraGroups = [ "gamemode" ];

  # per game only (`gamescope -- %command%`): forced resolution, FSR, frame
  # cap, or a game that fights the tiling compositor. No login session.
  programs.gamescope.enable = true;
  # NOT set (revisit if ever needed):
  #   enableWsi — HDR WSI layer, pulls i686 pkgs
  #   capSysNice — OFF: Steam-FHS conflict + NVIDIA gamescope#521

  services.pipewire.alsa.support32Bit = true; # 32-bit game audio (i686)

  environment.systemPackages = with pkgs; [
    mangohud
    steam-run # FHS escape hatch
  ];
}
