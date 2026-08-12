{ pkgs, ... }:
{
  home.packages = with pkgs; [
    awww
  ];

  programs.niri.settings.spawn-at-startup = [
    { command = [ "awww-daemon" ]; }
    { command = [ "awww" "img" "/workspaces/nix-config/assets/kawaii-cat-girl.png" ]; }
  ];
}
