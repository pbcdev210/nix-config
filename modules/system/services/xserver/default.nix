{ config, ... }:
{
  services.xserver = {
    enable = true;
    videoDrivers = config.host-config.gpuDrivers;
  };
}
