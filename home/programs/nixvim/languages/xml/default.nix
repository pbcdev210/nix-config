{
  programs.nixvim.plugins.lsp.servers.lemminx = {
    enable = true;
  };

  programs.nixvim.plugins.treesitter.settings.ensure_installed = [ "xml" ];

  programs.nixvim.plugins.conform-nvim.settings.formatters_by_ft = { xml = [ "xmlformatter" ]; };
}
