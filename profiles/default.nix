{ profile }:
{
  inherit ((import ./${profile}.nix)) nixos;
  inherit ((import ./${profile}.nix)) home;
}
