{ pkgs, ... }:
{
  imports = [
    ./shell-plugins.nix
  ];

  home.packages = with pkgs; [
    nixd
    treefmt
    sops
    jq
    file
    wifitui
  ];
}
