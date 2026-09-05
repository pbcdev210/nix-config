{
  extraOverlays,
  inputs,
  nixpkgsConfig,
  argv,
}:
let
  inherit (argv) base;

  overlays =
    extraOverlays
    ++ [ (final: prev: argv) ]
    ++ (import "${base.overlays}" argv)
    ++ (import "${base.pkgs}" argv);
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
