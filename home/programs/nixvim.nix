{ config, inputs, pkgs, ... }:
{
  home.packages = [
    inputs.self.packages.${pkgs.stdenv.system}.nixvim
  ];

  programs.neovide = {
    enable = true;
    settings = {
      font.size = config.stylix.fonts.sizes.terminal;
      font.normal = config.stylix.fonts.monospace.name;
      wayland-app-id = "neovim";
    };
  };
}
