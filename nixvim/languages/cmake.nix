{
  programs.nixvim.plugins.lsp.servers.neocmake = {
    enable = true;
  };

  programs.nixvim.plugins.treesitter.settings.ensure_installed = [
    "cmake"
  ];

  programs.nixvim.plugins.conform-nvim.settings.formatters_by_ft = {
    cmake = [ "gersemi" ];
  };
}

