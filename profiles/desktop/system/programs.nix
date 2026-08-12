{ dirs, ... }:
{
  imports = [
    "${dirs.system.programs}/nix-ld"
    "${dirs.system.programs}/zsh"
    "${dirs.system.programs}/fish"
  ];
}
