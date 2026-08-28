{ settings, pkgs, ... }:
{
  system.stateVersion = "26.05";

  time.timeZone = settings.timeZone;
  i18n.defaultLocale = settings.locale;

  environment.systemPackages = [ pkgs.mkcert ];

  imports = [
    ./keyboard
    ./options
    ./audio.nix
    ./bluetooth.nix
    ./networking.nix
    ./nix.nix
    ./security.nix
    ./shell.nix
    ./sops.nix
    ./users.nix
    ./xdg.nix
  ];
}
