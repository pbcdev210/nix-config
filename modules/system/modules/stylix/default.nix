{ inputs, pkgs, ... }:
{
  stylix = {
    enable = true;

    base16Scheme = "${inputs.schemes}/base16/nightfox-carbonfox.yaml";

    polarity = "dark";

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    autoEnable = false;
  };

  imports = [
    ./fonts.nix
  ];
}

