{ inputs, pkgs, ... }: {
  extraPlugins = with inputs; [
    treesitter-kanata.packages.${pkgs.stdenv.system}.default
  ];
}
