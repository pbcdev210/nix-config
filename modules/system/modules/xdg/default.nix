{ pkgs, ... }:
{
  xdg.portal = {
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    enable = true;
  };

  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];
}
