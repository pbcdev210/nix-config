{ settings, ... }:
{
  nix.registry.nixpkgs.to = {
    type = "path";
    path = settings.dirs.nixConfig;
  };
}
