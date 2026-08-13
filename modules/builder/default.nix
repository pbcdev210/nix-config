{ extraHomeModules, extraNixosModules, overlays, inputs }:
let
  mkPkgs = { system, extraOverlays ? [ ] }: import inputs.nixpkgs {
    overlays = overlays ++ extraOverlays ++
      (import "${inputs.self}/overlays");
    localSystem = system;
    config.allowUnfree = true;
  };

  extraArgv = import ./argv { inherit inputs; };

  homeRaw = import ./home {
    inherit inputs extraHomeModules extraArgv mkPkgs;
    inherit mkHomeModules; #  to support the non-standalone configuration
  };

  systemRaw = import ./system { inherit inputs extraNixosModules extraArgv mkPkgs; mkHome = homeRaw.mkNonStandalone; };

  mkHomeModules = { profile, desktop }: [
    (import extraArgv.dirs.profiles { inherit profile; }).home
    (import extraArgv.dirs.desktops { inherit desktop; }).home
    "${extraArgv.dirs.home.root}/base.nix"
    ./home/options.nix
  ];

  mkSystemModules = { profile, desktop, host }: [
    (import extraArgv.dirs.profiles { inherit profile; }).system
    (import extraArgv.dirs.desktops { inherit desktop; }).system
    (import extraArgv.dirs.hosts { inherit host; })
    "${extraArgv.dirs.system.root}/base.nix"
    ./system/options.nix
  ];
in
{
  home = {
    mk =
      { name, desktop, profile, extraModules ? [ ], extraOverlays ? [ ], system }:
      homeRaw.mk {
        inherit name desktop profile extraOverlays system;
        extraModules = extraModules ++ (mkHomeModules { inherit desktop profile; });
      };
  };

  system = {
    mk =
      { name, desktop, profile, extraModules ? [ ], extraOverlays ? [ ], system, host, homeManager ? true }:
      systemRaw.mk {
        inherit name desktop profile extraOverlays system host homeManager;
        extraModules = extraModules ++ (mkSystemModules { inherit profile desktop host; });
      };
  };
}

