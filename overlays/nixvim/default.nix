{ inputs, ... }:
final: prev: {
  nixvim = inputs.self.nixvimConfiguration.${final.stdenv.system}.config.build.package;
}
