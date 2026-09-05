{ inputs, pkgs, ... }:
  inputs.self.nixvimConfiguration.${pkgs.stdenv.system}.config.build.package
