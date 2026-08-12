{ settings, pkgs, ... }:
{
  system.stateVersion = "26.05";

  time.timeZone = settings.timeZone;
  i18n.defaultLocale = settings.locale;

  imports = [
    ./modules/options
  ];

  environment.systemPackages = [ pkgs.mkcert ];
}
