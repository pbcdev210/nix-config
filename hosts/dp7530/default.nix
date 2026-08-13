{ pkgs, lib, ... }: {
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;
    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
      configurationLimit = 10;
      settings = {
        timeout = 4;
        force-menu = false;
        console-mode = "max";
      };
    };
  };

  imports = [
    ./hardware-configuration.nix
  ];

  services.scx.enable = true;
  services.scx.scheduler = "scx_rustland";

  host-config.gpuDrivers = [ "intel" ];
}
