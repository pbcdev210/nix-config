{ profile, }:
{
  system = import ./${profile}/system;
  home = import ./${profile}/home;
}
