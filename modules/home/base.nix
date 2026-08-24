{ settings, ... }:
{
  home.username = settings.identity.username;
  home.homeDirectory = settings.dirs.home;
  home.stateVersion = "26.05";

  imports = [ ];
}
