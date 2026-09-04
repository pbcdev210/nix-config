{ inputs }:
rec {
  nixConfig = "${inputs.self}";
  overlay = "${nixConfig}/overlays";
  assets = "${nixConfig}/assets";
  desktops = "${nixConfig}/desktops";
  profiles = "${nixConfig}/profiles";
  hosts = "${nixConfig}/hosts";
  data = "${nixConfig}/data";
  modules = "${nixConfig}/modules";
  pkgs = "${nixConfig}/pkgs";
  overlays = "${nixConfig}/overlays";

  nixos = rec {
    root = "${nixConfig}/nixos";
    services = "${root}/services";
    virtualisation = "${root}/virtualisation";
  };

  home = rec {
    root = "${nixConfig}/home";
    programs = "${root}/programs";
    services = "${root}/services";
    develop = "${root}/develop";
    apps = "${root}/apps";
    ides = "${root}/ides";
  };
}
