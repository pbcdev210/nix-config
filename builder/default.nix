{
  extraModules,
  extraOverlays,
  nixpkgsConfig,
  inputs,
}:
let
  argv' = import ./argv.nix { inherit inputs; };

  mkBuilderWithSelf =
    { self }:
    let
      argv'' = argv' // {
        builder = self;
      };

      argv = argv'' // {
        argv = argv'';
      };

      inherit (argv) base;

      mkNixosModules =
        {
          host,
          profile,
          desktop,
          extraNixosModules,
        }:
        extraModules.nixos
        ++ extraNixosModules
        ++ [
          "${base.modules}/nixos"
          (import base.hosts { inherit host; })
          (import base.profiles { inherit profile; }).nixos
          (import base.desktops { inherit desktop; }).nixos
        ];

      mkHomeModules =
        {
          profile,
          desktop,
          extraHomeModules,
        }:
        extraModules.home
        ++ extraHomeModules
        ++ [
          "${base.modules}/home"
          (import base.profiles { inherit profile; }).home
          (import base.desktops { inherit desktop; }).home
        ];

      mkNixvimModules =
        { profile, extraNixvimModules }:
        extraModules.nixvim
        ++ extraNixvimModules
        ++ [
          "${base.modules}/nixvim"
          (import base.profiles { inherit profile; }).nixvim
        ];

      inherit
        (import ./pkgs.nix {
          inherit
            extraOverlays
            nixpkgsConfig
            inputs
            argv
            ;
        })
        mkPkgs
        ;

      home = import ./home.nix { inherit mkPkgs mkHomeModules argv; };
      nixos = import ./nixos.nix {
        inherit mkPkgs mkNixosModules argv;
        mkHome = home.mkNonStandalone;
      };
      nixvim = import ./nixvim.nix { inherit mkPkgs mkNixvimModules argv; };
    in
    {
      inherit mkPkgs;
      mkNixos = nixos.mk;
      mkHome = home.mk;
      mkNixvim = nixvim.mk;
      mkNvimPkg = nixvim.mkPackage;
    };

  output = mkBuilderWithSelf { self = output; };
in
output
