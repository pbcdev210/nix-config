{ inputs, pkgs, ... }:
{
  home.packages = [
    inputs.wps-office.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.wps-office.packages.${pkgs.stdenv.hostPlatform.system}.fonts
  ];
}
