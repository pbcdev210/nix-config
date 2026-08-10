{ inputs, ... }:
{
  programs.nixvim = {
    enable = true;
    nixpkgs.source = inputs.nixpkgs;
  };

  imports = [
    ./core
    ./direnv
    ./edit
    ./file
    ./git
    ./languages
    ./project
    ./terminal
    ./ui
    ./utils
    ./workspace
  ];

  stylix.targets.nixvim.enable = false;
  stylix.targets.neovim.enable = false;
}
