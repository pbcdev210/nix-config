{ pkgs, config, ... }:
{
  home.packages = [ pkgs.copyq ];

  xdg.configFile."copyq/copyq.conf".source = ./copyq.conf;
  xdg.configFile."copyq/themes".source = ./themes;
}
