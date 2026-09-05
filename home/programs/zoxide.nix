{ pkgs, base, ... }:
let
  zoxidePaths = [
    base.paths.home
    "${base.paths.home}/.config"

    "/workspaces"
    base.paths.dotfiles
    base.paths.dotfilesBot
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
