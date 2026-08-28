{ mkPkgs, mkNixvimModules, argv }:
let
  inherit (argv) inputs;
in
{
  mk = { system, extraNixvimModules ? [ ] }:
    let
      pkgs = mkPkgs { inherit system; };
      modules = (mkNixvimModules { inherit extraNixvimModules; }) ++ [
        {
          nixpkgs.pkgs = pkgs;
        }
      ];
    in
    inputs.nixvim.lib.evalNixvim {
      inherit modules;
      extraSpecialArgs = argv;
    };
}
