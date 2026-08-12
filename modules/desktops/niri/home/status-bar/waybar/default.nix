{ config, ... }:
{
  programs.waybar = {
    enable = true;

    style = builtins.readFile ./style.css;
  };

  xdg.configFile."waybar/config.jsonc".source = config.lib.file.mkOutOfStoreSymlink ./config.jsonc;

  programs.niri.settings.spawn-at-startup = [{ argv = [ "waybar" ]; }];
  stylix.targets.waybar.enable = true;
}
