{ base, ... }:
{
  programs.nh = {
    enable = true;

    flake = "${base.paths.dotfiles}";
  };
  home.sessionVariables = {
    NH_HOME_FLAKE = "${base.paths.dotfiles}";
  };
}
