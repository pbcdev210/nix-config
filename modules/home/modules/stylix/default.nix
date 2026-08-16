{ config, ... }:
{
  fonts.fontconfig.enable = true;

  home.packages = [
    config.stylix.fonts.serif.package
    config.stylix.sansSerif.package
    config.stylix.monospace.package
    config.stylix.emoji.package
  ];
}
