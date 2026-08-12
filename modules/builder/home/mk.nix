{ inputs, extraArgv, mkPkgs, name, desktop, profile, extraOverlays, system, extraModules }:
let
  pkgs = mkPkgs { inherit system extraOverlays; };

  modules = [
    optionsSet
  ] ++ extraModules;

  optionsSet = {
    config.name = name;
    config.desktop = desktop;
    config.profile = profile;
  };
in
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs modules;
  extraSpecialArgs = extraArgv;
}




