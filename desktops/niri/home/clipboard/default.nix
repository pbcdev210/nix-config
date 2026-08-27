{ pkgs, ... }:
{
  home.packages = [
    pkgs.wl-clipboard
  ];

  imports = [ ./clipse ];
}
