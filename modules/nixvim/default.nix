{ inputs, ... }:
{
  programs.nixvim = {
    enable = true;
    nixpkgs.source = inputs.nixpkgs;
  };

  imports = [
    inputs.nixvim.homeModules.nixvim

    ./core
    ./direnv
    ./edit
    ./file
    ./git
    ./img
    ./languages
    ./learn
    ./neovide
    ./project
    ./terminal
    ./ui
    ./utils
    ./windown
    ./workspace
  ];

  stylix.targets.nixvim.enable = false;
  stylix.targets.neovim.enable = false;
}
