{ inputs, ... }: {
  imports = with inputs; [
    treesitter-kanata.homeManagerModules.nixvim
  ];
}
