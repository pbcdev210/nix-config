{
  extraOverlays,
  inputs,
  nixpkgsConfig,
  argv,
}:
let
  inherit (argv) dirs;

  overlays =
    extraOverlays
    ++ [ (final: prev: argv) ]
    ++ (import "${dirs.overlays}" argv)
    ++ (import "${dirs.pkgs}" argv);
  config = nixpkgsConfig;
in
{
  mkPkgs =
    {
      system,
      extraNixpkgsArgs ? { },
    }:
    import inputs.nixpkgs (
      {
        inherit overlays config;
        localSystem = system;
      }
      // extraNixpkgsArgs
    );
}
