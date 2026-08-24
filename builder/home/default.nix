{ inputs, extraHomeModules, extraArgv, mkPkgs, mkHomeModules }: {
  mk = { name, desktop, profile, extraModules, extraOverlays, system }: (import ./mk.nix {
    inherit inputs extraArgv mkPkgs name desktop profile extraOverlays system;
    extraModules = extraHomeModules ++ extraModules;
  });

  mkNonStandalone = {}: (import ./standalone.nix {
    inherit extraArgv mkHomeModules;
    extraModules = extraHomeModules;
  });
}
