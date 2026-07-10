# AMD Radeon Navi 22 (RX 6700 XT class, 12G/192bit) — amdgpu is in-kernel;
# Vulkan/RADV comes with mesa defaults.
{ ... }:
{
  services.xserver.videoDrivers = [ "modesetting" ];
}
