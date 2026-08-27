{ profile, }:
{
  system = import ./${profile}/system.nix;
  home = import ./${profile}/home.nix;
}
