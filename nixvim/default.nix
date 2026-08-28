{ inputs, ... }:
{
  nixpkgs.source = inputs.nixpkgs;

  imports = [
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
}
