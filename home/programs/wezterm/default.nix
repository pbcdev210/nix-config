{ config, base, ... }:
{
  programs.wezterm = {
    enable = true;

    settings = {
      background = [
        {
          source = {
            File = config.lib.file.mkOutOfStoreSymlink "${base.assets}/kawaii-cat-girl.png";
          };
          hsb = {
            brightness = 0.10;
          };
        }
      ];
    };
    extraConfig = builtins.readFile ./wezterm.lua;
  };

  stylix.targets.wezterm.enable = true;
}
