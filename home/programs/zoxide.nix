{ pkgs, settings, ... }:
let
  zoxidePaths = [
    settings.dirs.home
    "${settings.dirs.home}/.config"

    "/workspaces"
    settings.dirs.nixConfig
    settings.dirs.nixConfigBot
  ];
in
{
  programs.zoxide = {
    enable = true;
  };

  home.activation.seedZoxide = ''
    ${builtins.concatStringsSep "\n" (map (path: "${pkgs.zoxide}/bin/zoxide add ${path}") zoxidePaths)}
  '';
}
