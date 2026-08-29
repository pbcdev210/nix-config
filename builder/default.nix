{
  extraModules,
  extraOverlays,
  inputs,
}:
let
  argv' = import ./argv { inherit inputs; };
  argv = {
    argv = argv';
  }
  // argv';
  inherit (argv) dirs;
  overlays = extraOverlays ++ (import "${dirs.overlays}" argv) ++ (import "${dirs.pkgs}" argv);

  mkPkgs =
    { system }:
    import inputs.nixpkgs {
      inherit overlays;
      localSystem = system;
      config.allowUnfree = true;
    };

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
