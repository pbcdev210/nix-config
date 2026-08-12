{ settings, ... }:
{
  programs.nh = {
    enable = true;

    flake = "${settings.dirs.nixConfig}";
  };
  home.sessionVariables = {
    NH_HOME_FLAKE = "${settings.dirs.nixConfig}";
  };
}
