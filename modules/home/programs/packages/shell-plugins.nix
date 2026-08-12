{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fzf
    grc
    libnotify
  ];
}
