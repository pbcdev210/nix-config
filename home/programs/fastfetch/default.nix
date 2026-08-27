{ dirs, ... }:
{
  programs.fastfetch = {
    enable = true;
  };
  xdg.configFile."fastfetch/config.jsonc".source = ./config.jsonc;
  xdg.configFile."fastfetch/logo/nixos.webp".source = "${dirs.assets}/logo/nixos.webp";
}
