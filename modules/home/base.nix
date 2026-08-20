{ settings, pkgs, ... }:
{
  home.username = settings.identity.username;
  home.homeDirectory = settings.dirs.home;
  home.stateVersion = "26.05";

  imports = [ ];

  home.packages = [
    pkgs.nixd
    pkgs.treefmt
    pkgs.sops
    pkgs.jq
  ];
}
