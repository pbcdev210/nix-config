{ inputs }:
rec {
  nixConfig = "${inputs.self}";
  overlay = "${nixConfig}/overlays";
  assets = "${nixConfig}/assets";
  desktops = "${nixConfig}/desktops";
  profiles = "${nixConfig}/profiles";
  hosts = "${nixConfig}/hosts";
  data = "${nixConfig}/data";

  system = rec {
    root = "${nixConfig}/system";
    programs = "${root}/programs";
    services = "${root}/services";
  };

  home = rec {
    root = "${nixConfig}/home";
    programs = "${root}/programs";
    services = "${root}/services";
    develop = "${root}/develop";
  };
}
