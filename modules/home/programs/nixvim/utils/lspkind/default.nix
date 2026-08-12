{
  programs.nixvim.plugins.lspkind = {
    enable = true;
  };

  imports = [
    ./icons.nix
  ];
}

