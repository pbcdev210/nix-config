{ dirs, ... }:
let
  r = dirs.home.root;
  p = dirs.home.programs;
  s = dirs.home.services;
  d = dirs.home.develop;
in
{

  imports = [
    "${r}/apps"
    "${r}/develops"
    "${r}/flatpak"
    "${r}/inputs-medthod"
    "${r}/stylix"
    "${r}/gtk.nix"
    "${r}/sops.nix"
    "${r}/systemd"
  ];
}
