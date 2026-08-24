{ inputs, extraArgv, mkPkgs, mkHome, name, desktop, profile, extraModules, extraOverlays, system, host, homeManager }:
let
  pkgs = mkPkgs { inherit system extraOverlays; };
  modules = [
    optionsSet
  ] ++ extraModules
  ++ (if homeManager then [
    (import ./home.nix { inherit mkHome; })
  ] else [ ]);

  optionsSet = {
    config.name = name;
    config.desktop = desktop;
    config.profile = profile;
    config.host = host;
  };
in

inputs.nixpkgs.lib.nixosSystem
{
  inherit system pkgs modules;
  specialArgs = extraArgv;
}
