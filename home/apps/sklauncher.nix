{ inputs, pkgs, ... }:
{
  home.packages = with inputs; [
    sklauncher.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
