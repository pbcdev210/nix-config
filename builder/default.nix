{
  extraModules,
  extraOverlays,
  nixpkgsConfig,
  inputs,
}:
let
  argv' = import ./argv { inherit inputs; };
  argv = {
    argv = argv';
  }
  // argv';
  inherit (argv) dirs;

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
      "${dirs.modules}/nixos"
      (import dirs.hosts { inherit host; })
      (import dirs.profiles { inherit profile; }).nixos
      (import dirs.desktops { inherit desktop; }).nixos
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
      "${dirs.modules}/home"
      (import dirs.profiles { inherit profile; }).home
      (import dirs.desktops { inherit desktop; }).home
    ];

  mkNixvimModules =
    { extraNixvimModules }:
    extraModules.nixvim
    ++ extraNixvimModules
    ++ [
      "${dirs.nixConfig}/nixvim"
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
  nixvim = nixvim.mk;
}
