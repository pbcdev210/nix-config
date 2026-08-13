{ pkgs, dirs, ... }:
{
  home.packages = with pkgs; [
    awww
  ];

  programs.niri.settings.spawn-at-startup = [
    { command = [ "awww-daemon" ]; }
    { command = [ "awww" "img" "${dirs.assets}/kawaii-cat-girl.png" ]; }
  ];
}
