{ config, pkgs, ... }:
{
  programs.niri.enable = true;
  programs.niri.packages = pkgs.niri;

  services.displayManager.sddm.wayland.enable = true;

  imports = [
    ./dm
  ];

  services.xserver = {
    enable = true;
    videoDrivers = config.host-config.gpuDrivers;
  };

}
