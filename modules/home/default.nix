{ settings, ... }:
{
  home.username = settings.identity.username;
  home.homeDirectory = settings.dirs.home;
  home.stateVersion = "26.05";

  imports = [
    ./input-method
    ./programs
    ./services
    ./gtk.nix
    ./nix-config.nix
    ./sops.nix
    ./theme.nix
    ./systemd.nix
  ];
}
