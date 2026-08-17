{ pkgs, config, ... }:
{
  stylix.fonts = {
    serif = {
      package = pkgs.noto-fonts;
      name = "Noto Serif";
    };

    sansSerif = {
      package = pkgs.nerd-fonts.ubuntu-sans;
      name = "UbuntuSans NF";
    };

    monospace = {
      package = pkgs.nerd-fonts.fira-code;
      name = "FiraCode Nerd Font Mono";
    };

    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };

    sizes = {
      terminal = 9;
    };
  };

  fonts.fontconfig.enable = true;

  home.packages = [
    config.stylix.fonts.serif.package
    config.stylix.fonts.sansSerif.package
    config.stylix.fonts.monospace.package
    config.stylix.fonts.emoji.package
    pkgs.inter
    pkgs.dejavu_fonts
  ];
}

