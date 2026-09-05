{ base, ... }:
{
  programs.fastfetch = {
    enable = true;
  };
  xdg.configFile."fastfetch/config.jsonc".source = ./config.jsonc;
  xdg.configFile."fastfetch/logo/nixos.webp".source = "${base.assets}/logo/nixos.webp";
}
