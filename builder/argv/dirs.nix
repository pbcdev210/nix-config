{ inputs }:
rec {
  nixConfig = "${inputs.self}";
  overlay = "${nixConfig}/overlays";
  assets = "${nixConfig}/assets";
  desktops = "${nixConfig}/modules/desktops";
  profiles = "${nixConfig}/profiles";
  hosts = "${nixConfig}/hosts";
  modules = "${nixConfig}/modules";

  system = rec {
    root = "${nixConfig}/modules/system";
    programs = "${root}/programs";
    services = "${root}/services";
    modules = "${root}/modules";
  };

  home = rec {
    root = "${nixConfig}/modules/home";
    programs = "${root}/programs";
    services = "${root}/services";
    modules = "${root}/modules";
    develop = "${root}/develop";
  };
}
