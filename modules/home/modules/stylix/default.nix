{ inputs, pkgs, ... }:
{
  stylix = {
    enable = true;

    base16Scheme = "${inputs.schemes}/base16/nightfox-carbonfox.yaml";

    polarity = "dark";

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 22;
    };

    opacity = {
      terminal = 0.5;
      applications = 0.9;
      desktop = 0.9;
      popups = 0.95;
    };

    autoEnable = false;
  };

  imports = [
    inputs.stylix.homeModules.stylix

    ./fonts.nix
  ];
}
