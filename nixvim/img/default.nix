{ pkgs, ... }:
{
  programs.nixvim.extraPackages = [ pkgs.imagemagick ];
  imports = [ ./image-snacks.nix ];
}
