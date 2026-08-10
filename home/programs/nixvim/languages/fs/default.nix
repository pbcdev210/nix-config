{
  programs.nixvim.plugins.lsp.servers.fsautocomplete = {
    enable = true;
  };

  programs.nixvim.plugins.conform-nvim.settings.formatters_by_ft = { fs = [ "fsharp" ]; };

  programs.nixvim.plugins.treesitter.settings.ensure_installed = [ "fsharp" ];
}
