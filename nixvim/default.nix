{ inputs, ... }:
{
  programs.nixvim = {
    enable = true;
    nixpkgs.source = inputs.nixpkgs;
  };

  imports = [
    inputs.nixvim.homeModules.nixvim

    ./core
    ./edit
    ./file
    ./git
    ./img
    ./languages
    ./learn
    ./terminal
    ./ui
    ./utils
    ./windown
    ./workspace

    ./direnv.nix
    ./neovide.nix
  ];

  stylix.targets.nixvim.enable = false;
  stylix.targets.neovim.enable = false;
}
