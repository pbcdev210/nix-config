{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    vivaldi
    vivaldi-ffmpeg-codecs

    spotify

    sklauncher

    inputs.wps-office.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.wps-office.packages.${pkgs.stdenv.hostPlatform.system}.fonts
  ];
}
