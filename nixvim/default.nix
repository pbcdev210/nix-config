{ inputs, ... }:
{
  nixpkgs.source = inputs.nixpkgs;

  imports = [
    ./core
    ./edit
    ./file
    ./git
    ./languages
    ./learn
    ./terminal
    ./ui
    ./utils
    ./workspace

    ./direnv.nix
    ./img.nix
    ./neovide.nix
    ./obsidian.nix
    ./windown.nix
  ];
}
