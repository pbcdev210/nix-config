{ dirs, ... }:
{
  imports = [
    "${dirs.system.modules}/bluetooth"
    "${dirs.system.modules}/keyboard"
    "${dirs.system.modules}/ldLibraries"
    "${dirs.system.modules}/networking"
    "${dirs.system.modules}/nix"
    "${dirs.system.modules}/security"
    "${dirs.system.modules}/users"
    "${dirs.system.modules}/xdg"
  ];
}
