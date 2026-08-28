{ inputs, pkgs, ... }:
{
  home.packages = with inputs; [
    wps-office.packages.${pkgs.stdenv.hostPlatform.system}.default
    wps-office.packages.${pkgs.stdenv.hostPlatform.system}.fonts
  ];
}
