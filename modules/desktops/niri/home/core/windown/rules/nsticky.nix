{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nsticky.homeModules.default
  ];

  programs.nsticky = {
    enable = true;
    menu = "${pkgs.fuzzel}/bin/fuzzel -d";
  };
}
