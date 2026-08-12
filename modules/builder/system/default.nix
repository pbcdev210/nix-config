{ inputs, extraNixosModules, extraArgv, mkPkgs, mkHome }:
{
  mk = { name, desktop, profile, extraModules, extraOverlays, system, host, homeManager }:
    (import ./mk.nix {
      inherit inputs extraArgv mkPkgs mkHome name desktop profile extraOverlays system host homeManager;
      extraModules = extraNixosModules ++ extraModules;
    });
}
