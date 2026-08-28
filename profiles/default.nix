{ profile, }:
{
  nixos = (import ./${profile}.nix).nixos;
  home = (import ./${profile}.nix).home;
}
