{ pkgs, settings, inputs, ... }:
{
  imports = with inputs; [
    sunix.homeModules.default
  ];

  programs.sunix = {
    enable = true;

    settings = {
      dixBinary = "${pkgs.dix}/bin/dix";
      flakeDir = settings.dirs.nixConfig;
      # TODO: use dynamic name
      homeFlake = "default";
      nixosFlake = "default";
      styleCss = null;
      showDemo = false;
    };
  };
}
