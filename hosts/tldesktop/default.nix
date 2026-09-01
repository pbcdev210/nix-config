{
  pkgs,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    systemd = {

    };
    consoleLogLevel = 0;
    initrd.verbose = false;

    # plymouth = {
    #   enable = true;
    #   theme = "bgrt";
    # };
  };

  # services.scx.enable = true;
  # services.scx.scheduler = "scx_rustland";

  host-config.gpuDrivers = [ "intel" ];

  imports = [
    # ./hardware-configuration.nix
  ];
}
