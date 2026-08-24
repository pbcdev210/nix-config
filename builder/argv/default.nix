{ inputs }:
{
  dirs = import ./dirs.nix { inherit inputs; };
  settings = import "${inputs.self}/settings";
  inherit inputs;
}

