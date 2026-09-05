{ base, ... }:
{
  nix.registry.nixpkgs.to = {
    type = "path";
    path = base.paths.dotfiles;
  };
}
