{ lib, pkgs, ... }:
{
  options.ldLibraries = lib.mkOption {
    description = "List of libraries processed by nix-ld for third parties";
    type = lib.types.listOf lib.types.package;
    default = [ ];
  };
}
