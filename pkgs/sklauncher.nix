{ sources, pkgs, ... }:
let
  baseApp = pkgs.appimageTools.wrapType2 {
    pname = "sklauncher";
    version = "stable";
    src = sources."sklauncher-appimage-${pkgs.stdenv.system}";
    extraPkgs =
      p: with p; [
        glfw
        openal
        libGL
        libglvnd
        vulkan-loader
        libX11
        libXext
        libXcursor
        libXrandr
        libXinerama
        libXi
        libXxf86vm
      ];
  };

  desktopItem = pkgs.makeDesktopItem {
    name = "sklauncher";
    desktopName = "SKlauncher";
    comment = "An alternative Minecraft launcher";
    exec = "${baseApp}/bin/sklauncher";

    icon = builtins.fetchurl {
      url = "https://skmedix.pl/favicon.ico";
      sha256 = "1nqmb1bcpcjz2bzqy7jdcl65x8bs4nvkb8012ifwscqq1grs2arw";
    };

    categories = [ "Game" ];
    terminal = false;
  };
in
pkgs.symlinkJoin {
  name = "sklauncher";
  paths = [
    baseApp
    desktopItem
  ];

  postBuild = ''
    ln -sf ${baseApp}/bin/sklauncher $out/bin/sklauncher
  '';
}
