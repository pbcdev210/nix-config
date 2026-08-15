{ pkgs, ... }:
let
  vivaldi-config = {
    # commandLineArgs = "--ozone-platform-hint=auto --enable-features=UseOzonePlatform,VaapiVideoDecoder,CanvasOopRasterization --enable-gpu-rasterization";
    commandLineArgs = "--ozone-platform-hint=auto --enable-features=UseOzonePlatform,VaapiVideoDecoder,CanvasOopRasterization --enable-gpu-rasterization --enable-features=WebUIDarkMode --force-dark-mode";
  };
in
{
  home.packages = with pkgs; [
    (vivaldi.override vivaldi-config)
    vivaldi-ffmpeg-codecs
  ];
}
