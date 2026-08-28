{ pkgs, ... }:
{
  extraPackages = [ pkgs.imagemagick ];
  imports = [ ./image-snacks.nix ];
}
