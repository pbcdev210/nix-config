{ config, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries = config.ldLibraries;
  };
}
