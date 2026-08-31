{ settings, ... }:
{
  home.username = settings.identity.username;
  home.homeDirectory = settings.dirs.home;
  home.stateVersion = "26.05";

  imports = [
    ./input-method
    ./gtk.nix
    ./stylix.nix
    ./systemd.nix
    ./xdg.nix
  ];
}
