{ lib, flake-parts-lib, ... }:
let
  configurationType = lib.mkOptionType {
    name = "configuration";
    description = "configuration";
    descriptionClass = "noun";
    merge = lib.options.mergeOneOption;
    check = x: x._type or null == "configuration";
  };
in
flake-parts-lib.mkTransposedPerSystemModule {
  name = "nixvimConfiguration";
  option = lib.mkOption {
    type = configurationType;
    default = { };
    description = ''
      An attribute set of Nixvim configurations.
    '';
  };
  file = ./nixvimConfiguration.nix;
}
